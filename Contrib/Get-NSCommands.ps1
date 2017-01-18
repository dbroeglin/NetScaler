$res = Invoke-RestMethod 'http://172.16.124.11/nitro/v1/config/' -Headers @{
    "X-NITRO-USER" =  "nsroot"; "X-NITRO-PASS" = "nsroot" 
}

$res.configobjects.objects | Measure-Object

$res2 = Invoke-RestMethod 'http://172.16.124.11/nitro/v1/config/nsip' -Headers @{
    "X-NITRO-USER" =  "nsroot"; "X-NITRO-PASS" = "nsroot" 
}

$res3 = Invoke-WebRequest 'http://172.16.124.11/admin_ui/nitro_client/Nitro_result.js' -Headers @{
    "X-NITRO-USER" =  "nsroot"; "X-NITRO-PASS" = "nsroot" 
}
