namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.83
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "str(command_return_code == '0')"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_file
          - FAILURE: delete_file
    - delete_file:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "str(command_return_code == '0')"
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      string_equals:
        x: 412
        y: 14
      copy_artifact:
        x: 107
        y: 174
      copy_script:
        x: 594
        y: 165
      execute_script:
        x: 114
        y: 378
        navigate:
          1b1b9802-d0bb-68ee-b8b0-706287e5d1b0:
            vertices:
              - x: 213
                y: 407
              - x: 284.5
                y: 420.5
            targetId: delete_file
            port: SUCCESS
      delete_file:
        x: 375
        y: 383
      has_failed:
        x: 692
        y: 355
        navigate:
          afb3adfe-f398-17d9-17e7-f43f33b5721d:
            targetId: e04df553-46cb-2de6-635c-ba09d0bd1e37
            port: 'TRUE'
          93d0dfa3-8cd9-cd4e-7d4f-5a9aeca52def:
            targetId: c0abdbe3-dc59-31e4-56db-3b9e96ee4a65
            port: 'FALSE'
    results:
      SUCCESS:
        c0abdbe3-dc59-31e4-56db-3b9e96ee4a65:
          x: 834
          y: 293
      FAILURE:
        e04df553-46cb-2de6-635c-ba09d0bd1e37:
          x: 830
          y: 474
