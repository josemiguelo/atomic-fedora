[private]
default:
    @just --list

# Check Just Syntax
[group('Just')]
test:
    #!/usr/bin/bash
    echo "test!"
