# HELPER SCRIPTS

## How To Use

1. Add your script in same repo or pick any existing script.
2. https://raw.githubusercontent.com/mkyai/scripts/master/{script_name} , this will be your script url , eg: https://github.com/mkyai/scripts/blob/master/hello-world.sh
3. Run in CLI
a. for just executables
```bash
curl https://raw.githubusercontent.com/mkyai/scripts/master/hello-world.sh | bash
```

b. for input intractions
```bash
curl https://raw.githubusercontent.com/mkyai/scripts/master/hello-world.sh -o script.sh && chmod +x ./script.sh && ./script.sh
```
