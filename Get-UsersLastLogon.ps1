# Function that checks last logon date for a user account by checking in with all domain controllers
    # The script will print out most recent login times for each domain controller and at the end
    # show the most recent logon time and domain controller name
    function Get-UsersLastLogon{  
        param(
            [Parameter(Mandatory=$true)]
            $userName
        )
   
        $time = 0
        $getdc = Get-ADDomainController -Filter *
   
        foreach($dc in $getdc){
            try{
                $time = [datetime]::FromFileTime((Get-ADUser -Filter {Name -eq $userName} -Server $dc.Name -Properties LastLogon).lastLogon)
   
                if($time -gt $lastLogonTime -and $time -ne "Sunday, December 31, 1600 7:00:00 PM"){
                    $lastLogonTime = $time
                    $dcName = $dc.Name
                    Write-Host "Logged in at:" $lastLogonTime "with Domain Controller:" $dcName
                }
   
            }catch{
                Write-Host "CATCH STATEMENT"
            }          
        }
        Write-Host "Most Recent login at:" $lastLogonTime "with Domain Controller:" $dcName
    }
   
    Get-UsersLastLogon -userName "Marc Miller" # Enter the username the way it is shown in Active Directory ex. "Marc Miller"

