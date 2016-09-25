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

function Add-NSLBVirtualServerPolicyBinding {
    <#
    .SYNOPSIS
        Adds a rewrite policy.

    .DESCRIPTION
        Adds a rewrite policy.

    .EXAMPLE
        New-NSRewritePolicy -Name 'pol-rewrite' -ActionName 'act-rewrite' -Expression 'true'

        Creates a new rewrite policy which always applies the 'act-rewrite' action.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of rewrite policy.

    .PARAMETER ActionName
        The name of the action to execute when this policy is matched.

    .PARAMETER LogActionName
        The name of the log action to execute when this policy is matched.
        
        Default value: ""
        
    .PARAMETER Expression
        The rule/expression that has to be matched for this policy to apply.

        Minimum length: 0
        Maximum length: 8191
                
    .PARAMETER Comment
        Any information about the rewrite policy.

        Minimum length: 0
        Maximum length: 256

    .PARAMETER Passthru
        Return the newly created rewrite policy.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$VirtualServerName,

        [Parameter(Mandatory)]
        [ValidateSet('Rewrite', 'Traffic')] 
        [string]$PolicyType,

        [ValidateSet('Request', 'Response')] 
        [string]$BindPoint = $Null,

        [Parameter(Mandatory)]
        [string]$PolicyName,

        [int]$Priority = 100,

        [Parameter(Mandatory)]
        [ValidateSet('END', 'NEXT', 'USE_INVOCATION_RESULT')] 
        [string]$GotoPriorityExpression,
        
        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }
    
    process {
        if ($PSCmdlet.ShouldProcess($VirtualServerName, 'Add Virtual Server to Policy Binding')) {
            try {
                $PolicyTypeName = $(
                    switch($PolicyType) {
                        "Traffic" { "tmtraffic" }
                        default { $PolicyType.ToLower() }
                    }
                )
                $Resource = "lbvserver_$($PolicyTypeName)policy_binding"
                $params = @{
                    name                   = $VirtualServerName
                    bindpoint              = $BindPoint.ToUpper()
                    policyname             = $PolicyName
                    priority               = $Priority.ToString()
                    gotopriorityexpression = $GotoPriorityExpression.ToUpper()
                }
                _InvokeNSRestApi -Session $Session -Method PUT -Type $Resource -Payload $params -Action add
                
                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    throw "Not yet implemented"
                }
            } catch {
                throw $_
            }
        }        
        
        
    
        
    }   
}
