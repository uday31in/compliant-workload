# Policy Exemption required

| Policy Name | Policy ID | Reason |
|-------------|-----------|--------|
| Logic apps should disable public network access | Deny-LogicApp-Public-Network | Azure Logic App will expose a webhook that must be reachable by sentinel via public IP. |
| Storage accounts should prevent shared key access | Deny-Storage-Shared-Key | Logic App has to communicate to Storage (file, queue, table) via Access Key. Azure RBAC does not seem to be supported today. |
