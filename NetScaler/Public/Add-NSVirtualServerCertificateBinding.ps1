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

function Add-NSVirtualServerCertificateBinding {
     <#
    .SYNOPSIS
        Adds a new binding between an SSL virtual server and a certificate-key pair.

    .DESCRIPTION
        Adds a new binding between an SSL virtual server and a certificate-key pair.

    .EXAMPLE
        Add-NSVirtualServerCertificateBinding -VirtualServerName 'vserver01' -CertificateName 'vserver01-cert'

        Bind the certificate-key pair 'vserver01-cert' to virtual server 'vserver01'.

    .EXAMPLE
        $x = Add-NSVirtualServerCertificateBinding -VirtualServerName 'vserver01' -CertificateName 'vserver01-cert' -Force -PassThru
    
        Bind the certificate-key pair 'vserver01-cert' to virtual server 'vserver01',
        suppress the confirmation and returl the result.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VitualServerName
        Name for the virtual server. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain
        only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@), equal sign (=),
        and hyphen (-) characters. Can be changed after the virtual server is created.

        Minimum length = 1

    .PARAMETER CertificateName
        The certificate-key pair that will be bound to the selected load balancing virtual server.

    .PARAMETER SNICert
        If set, the bound certificate-key pair will be used in SNI processing.

        Default value: $False

    .PARAMETER Force
        Suppress confirmation when binding the certificate-key pair to the virtual server.

    .PARAMETER Passthru
        Return the binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $Script:Session,

        [parameter(Mandatory)]
        [string]$VirtualServerName = (Read-Host -Prompt 'LB virtual server name'),

        [parameter(Mandatory)]
        [string]$CertificateName,

        [switch]$SNICert = $False,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($VirtualServerName, 'Add Virtual Server to Certificate-Key Binding')) {
            try {
                $SNICertValue = $(if ($SNICert) { "true" } else { "false" })
                $params = @{
                    vservername = $VirtualServerName
                    certkeyname = $CertificateName
                    snicert     = $SNICertValue
                }
                _InvokeNSRestApi -Session $Session -Method PUT -Type sslvserver_sslcertkey_binding -Payload $params -Action add
                
                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSVirtualServerCertificateBinding -Session $Session -Name $VirtualServerName
                }
            } catch {
                throw $_
            }
        }
    }
}