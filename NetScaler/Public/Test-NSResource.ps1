<#
Copyright 2017 Dominique Broeglin

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

Set-Variable -Name ValidResourceTypes -Option Constant -Value @{
AAAGroup                      = 'aaagroup'
AAAGroupBinding               = 'aaagroup_binding'
AAAUser                       = 'aaauser'
AAAUserBinding                = 'aaauser_binding'
AAAVirtualServer              = 'authenticationvserver'
Backup                        = 'systembackup'
Config                        = 'nsrunningconfig'
Config                        = 'nssavedconfig'
CSAction                      = 'csaction'
CSPolicy                      = 'cspolicy'
CSVirtualServer               = 'csvserver'
CSVirtualServerResponderPolicyBinding= 'csvserver_responderpolicy_binding'
DnsNameServer                 = 'dnsnameserver'
DnsSuffix                     = 'dnssuffix'
Feature                       = 'nsfeature'
Hostname                      = 'nshostname'
IP6Resource                   = 'nsip6'
IPResource                    = 'nsip'
KCDAccount                    = 'aaakcdaccount'
LBMonitor                     = 'lbmonitor'
LBServer                      = 'server'
LBServiceGroup                = 'servicegroup'
LBServiceGroupMember          = 'servicegroup_servicegroupmember_binding'
LBServiceGroupMemberBinding   = 'servicegroup_servicegroupmember_binding'
LBServiceGroupMonitor         = 'servicegroup_lbmonitor_binding'
LBServiceGroupMonitorBinding  = 'servicegroup_lbmonitor_binding'
LBSSLVirtualServer            = 'sslvserver'
LBSSLVirtualServerCertificateBinding= 'sslvserver_sslcertkey_binding'
LBSSLVirtualServerProfile     = 'sslvserver'
LBVirtualServer               = 'lbvserver'
LBVirtualServerBinding        = 'lbvserver_service_binding'
LBVirtualServerBinding        = 'lbvserver_servicegroup_binding'
LBVirtualServerResponderPolicyBinding= 'lbvserver_responderpolicy_binding'
LBVirtualServerRewritePolicyBinding= 'lbvserver_rewritepolicy_binding'
LDAPAuthenticationPolicy      = 'authenticationldappolicy'
LDAPAuthenticationServer      = 'authenticationldapaction'
Mode                          = 'nsmode'
NTPServer                     = 'ntpserver'
ResponderAction               = 'responderaction'
ResponderPolicy               = 'responderpolicy'
RewriteAction                 = 'rewriteaction'
RewritePolicy                 = 'rewritepolicy'
SAMLAuthenticationPolicy      = 'authenticationsamlpolicy'
SAMLAuthenticationServer      = 'authenticationsamlaction'
SSLBVirtualServerProfile      = 'sslvserver'
SSLCertificate                = 'sslcertkey'
SSLCertificateLink            = 'sslcertlink'
SSLProfile                    = 'sslprofile'
SystemFile                    = 'systemfile'
TimeZone                      = 'nsconfig'
VPNServer                     = 'vpnserver'
VPNSessionPolicy              = 'vpnsessionpolicy'
VPNSessionProfile             = 'vpnsessionaction'
VPNVirtualServer              = 'vpnvserver'
VPNVirtualServerBinding       = '$policyType'
VPNVirtualServerTheme         = 'vpnvserver_vpnportaltheme_binding'
}
function Test-NSResource {
    <#
    .SYNOPSIS
        Tests the existence of a given resource

    .DESCRIPTION
        Tests if a resource for a given type and name exist.

    .EXAMPLE
        Test-NSResource -Type LBServer -Name srv-dummy

        Tests if server 'srv-dummy' of type LBServer exists.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the resource to test for.

    .PARAMETER Type
        The type of the resource to test for.
    #>
    [CmdletBinding()]
    Param(
        $Session = $Script:session,

        [parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateScript({ $ValidResourceTypes.Contains($_) })]
        [string]$Type,

        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        _AssertNSVersion -MinimumVersion '11.0'
    }

    process {
        foreach ($item in $Name) {
            $true -and (_InvokeNSRestApiGet -Session $Session -Type $ValidResourceTypes[$Type] -Name $item -ErrorAction SilentlyContinue)
        }
    }
}
