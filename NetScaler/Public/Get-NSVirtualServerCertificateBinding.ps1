<#
Copyright 2016 Dominique Broeglin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function Get-NSVirtualServerCertificateBinding {
    <#
    .SYNOPSIS
        Gets the specified virtual server certificate-key pair binding object(s).

    .DESCRIPTION
        Gets the specified virtual server certificate-key pair binding object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSVirtualServerCertificateBinding

        Get all virtual server certificate-key pair binding objects.

    .EXAMPLE
        Get-NSVirtualServerCertificateBinding -Name 'foobar'
    
        Get the virtual server certificate-key pair binding named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the virtual server certificate-key pair bindings to get.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Mandatory = $true, Position=0, ParameterSetName='get')]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        _InvokeNSRestApiGet -Session $Session -Type sslvserver_sslcertkey_binding -Name $Name
    }
}
