namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: 10.0.46.83
    - account_service_host: 10.0.46.83
    - db_host: 10.0.46.83
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/'
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "db_host+' postgres admin '+tomcat_host+' '+account_service_host"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - artifact_url: "url+war.lower()+'/target/'+war+'.war'"
              - parameters: "db_host+' postgres admin '+tomcat_host+' '+account_service_host"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 153
        y: 105
      deploy_tm_wars:
        x: 379
        y: 109
        navigate:
          508ede77-9bc7-fdf6-131e-f81892e2e76d:
            targetId: 9c366d28-088e-4991-a1b2-3e53d428b486
            port: SUCCESS
    results:
      SUCCESS:
        9c366d28-088e-4991-a1b2-3e53d428b486:
          x: 647
          y: 134
