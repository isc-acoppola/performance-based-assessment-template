# bssa-assessment
Unit tests for performance-based assessments

# Integration with AVL learning labs.
IRIS container
- Base Image: Use latest stable IRIS build – community Edition is fine.
- File system
  - Copy this repository into /usr/irissys/assessment/ in the IRIS container
  - Make /usr/irissys/assessment/UnitTest/ in the IRIS container readable/writeable for all users

- IRIS instance
  - Add tech/demo user with %All role.
  - Compile files from the following folders into the USER namespace:
    - MySample
    - UnitTest

  - Put the following classes into deployed mode:
    - MySample.Dispatch
    - UnitTest.Q1.Test
    - UnitTest.Q2.Test
    - UnitTest.Q3.Test
            
  - Run these commands in the user namespace:
    - Define the path on the file system for unit test suite.
      - Set ^UnitTestRoot=”/usr/irissys/assessment/UnitTest/”
    - Define the path where frontend resides.
      - Set ^FrontEndBasePath="/usr/irissys/assessment/FrontEnd/"
            
  - Create web application:
    - Name: /unittests/rest
    - Namespace: USER
    - Enable: yes
    - Dispatch class: MySample.Dispatch
    - Allowed Authentication Methods: Unauthenticated
    - Application Roles: %All

codeserver container
- Include ObjectScript extension pack
- InterSystems ObjectScript connection, attached to USER namespace
- Export MySample package from USER namespace to /shared/ in codeserver

Totara launcher
- Show IDE link
- Show WebTerminal link
- Hide management portal link and external connection info
- Add link called Unit Test Application: http://[server:port]/bssa/unittests/rest/index.html
