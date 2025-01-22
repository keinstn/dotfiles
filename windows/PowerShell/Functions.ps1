function ll
{ 
    eza.exe -lh --git @args 
}

function vimdiff
{ 
    nvim -d @args 
}

function open
{
    Invoke-Item $args
}

function touch
{
    New-Item $args
}

function cut
{
    param(
        [Parameter(ValueFromPipeline=$True)] [string]$inputobject,
        [string]$delimiter='\s+',
        [string[]]$field
    )

    process
    {
        if ($null -eq $field)
        { 
            $inputobject -split $delimiter 
        } else
        {
            ($inputobject -split $delimiter)[$field] 
        }
    }
}

function New-Link ($target, $link)
{
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}
