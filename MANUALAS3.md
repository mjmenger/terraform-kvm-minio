## Manually create AS3 declaration
We'll step you through creating an AS3 declaration to configure the BIG-IP in front of your MinIO cluster.
### assumptions
The remainder of this document assumes the following:  
- the BIG-IP tenant/partition for this configuration is *minio*
- the application within the BIG-IP tenant is *minio*
- the destination address for the console virtual server is *192.168.0.17*
- the destination port for the console virtual server is *80*
- the destination address for the API virtual server is *192.168.0.18*
- the destination port for the API virtual server is *9000*
- the MinIO hosts have address from 192.168.0.8 through 192.168.0.11
- the console port on the MinIO hosts is 9001
- the API port on the MinIO hosts is 9000

Where your environment differs from these values, please make the necessary adjustments in the steps below.

### steps
1. copy `as3manualtemplate.json` to `as3-minio.json`  
you can use another name for the file, but the remainder of this document assumes `as3-minio.json`
2. search for "tenant_name" and replace it with "minio"
3. search for "application_name" and replace it with "minio"
4. search for "console_destination_address" and replace it with "192.168.0.17"
5. search for "console_destination_port" and replace it with "80"
6. search for "api_destination_address" and replace it with "192.168.0.18"
7. search for "api_destination_port" and replace it with "9000"
8. search for "api_waf_policy_url" and replace it with "https://raw.githubusercontent.com/mjmenger/waf-policy/refs/tags/0.3.2/minios3.json"
9. create the "members" element of the console and api pools
```json
    "members": [{
        "servicePort": 9001,
        "serverAddresses": [
            "192.168.0.8",
            "192.168.0.9",
            "192.168.0.10",
            "192.168.0.11"
        ]
    }],  
``` 
The `servicePort` value is 9001 for the **console** pool and 9000 for the **api**  pool. The serverAddresses value is a list of addresses for the MinIO hosts. In the template example, there are four hosts with addresses 192.168.0.8 to 192.168.0.11. Replace the list with addresses of your MinIO cluster hosts. 

If you want to specify your hosts by FQDN or identify them by service discovery, the [AS3 documentation](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/schema-reference.html#pool) covers how to specify the pool members declaration for several alternatives.

10. search for "console_members_declaration" and replace it with the members declaration you just created for the console pool (servicePort: 9001)
11. search for "api_members_declaration" and replace it with the members declaration you just created for the api pool (servicePort: 9000)


## Configure the BIG-IP
12. using F5's vscode extension, Postman, or your REST API tool of choice, POST the AS3 declaration you created to your BIG-IP. 

The example above creates a tenant/partition on your BIG-IP named 'minio'. Within the tenant there will be two virtual servers, one for the MinIO console and one for the MinIO API. 

## Test the BIG-IP configuration
13. Log into the MinIO cluster using the *console_destination_address* and *console_destination_port*. 
14. Run the **warp** benchmarking tool, pointing it to *api_destination_address* and *api_destination_port*