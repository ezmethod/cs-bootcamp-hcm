namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.83
    - username: root
    - password: admin@123
    - filename: deploy_war.sh
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 125
        y: 135
        navigate:
          85a69fd6-45c2-fa62-25e6-9a32b2ca376b:
            targetId: 0135e236-3593-9816-d184-1ad97e25be7a
            port: SUCCESS
    results:
      SUCCESS:
        0135e236-3593-9816-d184-1ad97e25be7a:
          x: 407
          y: 92
