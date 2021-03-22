cwlVersion: v1.0
class: CommandLineTool
baseCommand: echo
stdout: varikmp.cwl.txt
inputs:
  message:
    type: string
    inputBinding:
      position: 1
outputs:
  output:
    type: stdout