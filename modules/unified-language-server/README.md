Generated with

```sh
node2nix -14 -i node-package.json
nix-env -f default.nix -iA unified-language-serve
nix-env --rollback
```
