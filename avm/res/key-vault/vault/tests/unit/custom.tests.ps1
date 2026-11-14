param (
    [Parameter(Mandatory = $true)]
    [array] $moduleFolderPaths,

    [Parameter(Mandatory = $true)]
    [string] $repoRootPath
)

BeforeAll {
    $moduleFolderPath = $moduleFolderPaths | Where-Object { $_ -match '[\\/]key-vault[\\/]vault$' }
    $moduleTemplate = Get-Content -LiteralPath (Join-Path $moduleFolderPath 'main.json') -Raw | ConvertFrom-Json -AsHashtable
}

Describe 'Key Vault public network access' {
    It 'Allows publicNetworkAccess value <value>' -ForEach @(
        @{ value = '' }
        @{ value = 'Enabled' }
        @{ value = 'Disabled' }
        @{ value = 'SecuredByPerimeter' }
    ) {
        $moduleTemplate.parameters.publicNetworkAccess.allowedValues | Should -Contain $value
    }

    It 'Preserves the automatic publicNetworkAccess default' {
        $moduleTemplate.parameters.publicNetworkAccess.defaultValue | Should -BeExactly ''
    }
}
