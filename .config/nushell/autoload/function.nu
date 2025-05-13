export def ln-s [src:path, dest:path] {
    if $nu.os-info.name == "windows" {
        pwsh -c $"New-Item -ItemType SymbolicLink -Path ($dest) -Value ($src)"
    } else {
        ^ln -s $src $dest
    }
}
