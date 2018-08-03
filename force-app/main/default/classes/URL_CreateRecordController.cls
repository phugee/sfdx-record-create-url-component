
/**
 * Author: Doug Ayers
 * Website: https://douglascayers.com
 * GitHub: https://github.com/douglascayers/sfdx-record-create-url-component
 * License: BSD 3-Clause License
 */
public class URL_CreateRecordController {

    /**
     * Returns basic field describe to know which fields
     * are or are not createable and updateable.
     *
     * @param objectName
     *      API name of the object whose field describe to return
     */
    @AuraEnabled
    public static Map<String, Object> getFieldDescribeMap( String objectName ) {

        Map<String, Object> fieldDescribeMap = new Map<String, Object>();

        // Performance trick to use Type.forName instead of Schema.getGlobalDescribe()
        // https://salesforce.stackexchange.com/a/32538/987
        // https://salesforce.stackexchange.com/a/219010/987
        Type reflector = Type.forName( objectName );
        SObject obj = (SObject) reflector.newInstance();
        SObjectType objType = obj.getSObjectType();

        DescribeSObjectResult describe = objType.getDescribe();
        Map<String, SObjectField> fieldsMap = describe.fields.getMap();
        for ( String fieldName : fieldsMap.keySet() ) {
			DescribeFieldResult fieldDescribe = fieldsMap.get( fieldName ).getDescribe();
            fieldDescribeMap.put( fieldDescribe.getName(), new Map<String, Object>{
                'accessible' => fieldDescribe.isAccessible(),
               	'createable' => fieldDescribe.isCreateable(),
                'updateable' => fieldDescribe.isUpdateable()
            });
        }

        return fieldDescribeMap;
    }

}
/*
BSD 3-Clause License
Copyright (c) 2018, Doug Ayers, douglascayers.com
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/