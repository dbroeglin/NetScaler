<#
Copyright 2015 Brandon Olin

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

function Add-NSCertKeyPair {
    <#
    .SYNOPSIS
        Add server certificate to NetScaler appliance.

    .DESCRIPTION
        Add server certificate to NetScaler appliance.

    .EXAMPLE

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertKeyName
        Name for the certificate and private-key pair. Must begin with an ASCII alphanumeric or underscore (_) character, 
        and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), 
        and hyphen (-) characters. Cannot be changed after the certificate-key pair is created. The following requirement
        applies only to the NetScaler CLI: If the name includes one or more spaces, enclose the name in double or single 
        quotation marks (for example, "my cert" or 'my cert').

    .PARAMETER CertPath
        Name of and, optionally, path to the X509 certificate file that is used to form the certificate-key pair.
        The certificate file should be present on the appliance's hard-disk drive or solid-state drive.
        Storing a certificate in any location other than the default might cause inconsistency in a high availability setup.
        '/nsconfig/ssl/' is the default path.

    .PARAMETER KeyPath
        Name of and, optionally, path to the private-key file that is used to form the certificate-key pair.
        The certificate file should be present on the appliance's hard-disk drive or solid-state drive.
        Storing a certificate in any location other than the default might cause inconsistency in a high availability setup. 
        '/nsconfig/ssl/' is the default path.

    .PARAMETER CertKeyFormat
        Input format of the certificate and the private-key files.
        The two formats supported by the appliance are:
            PEM - Privacy Enhanced Mail
            DER - Distinguished Encoding Rule.
        
        Default value: PEM
        Possible values = DER, PEM

    .PARAMETER Password
        Passphrase that was used to encrypt the private-key. Use this option to load encrypted private-keys in PEM format.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter()]
        [string]$CertKeyName,

        [Parameter()]
        [string]$CertPath,

        [Parameter()]
        [string]$KeyPath,

        [Parameter()]
        [ValidateSet("PEM","DER")]
        [string]$CertKeyFormat="PEM",

        [Parameter()]
        [securestring]$Password
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($CertKeyName, 'Add SSL certificate and private key pair')) {
            try {
                $params = @{
                    certkey = $CertKeyName
                    cert = $CertPath
                    inform = $CertKeyFormat
                }
                if ($PSBoundParameters.ContainsKey('KeyPath')) {
                    $params.key = $KeyPath
                }
                if ($CertKeyFormat -eq 'PEM' -and $Password) {
                    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
                    $unsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
                    $params.Add("passplain",$unsecurePassword)
                }
                $response = _InvokeNSRestApi  -Session $Session -Method POST -Type sslcertkey -Payload $params -Action add 
            } catch {
                throw $_
            }
        }
    }
}