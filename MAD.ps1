# MAD.ps1  aka Manage Active Directory


function mainMenu {
    $mainMenu = 'X'
    while($mainMenu -ne 'Q'){
        Clear-Host
        Write-Host "`n`t`t Gestion d'Active Directory`n"
        Write-Host -ForegroundColor Green " Menu Principal"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "1"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Gestion d'OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "2"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Gestion de Groupes"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "3"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Gestion d'Utilisateurs"
        $mainMenu = Read-Host "`n Selectionner une option [1,2,3] ou ecrire 'Q' pour quitter"
       
        # Activer sousmenu1
        if($mainMenu -eq 1){
            sousmenu1
        }
       
        # Activer sousmenu2
        if($mainMenu -eq 2){
            sousmenu2
        }

        # Activer sousmenu3
        if($mainMenu -eq 3){
            sousmenu3
        }
    }
}

function sousmenu1 {
    $sousmenu1 = 'X'
    while($sousmenu1 -ne 'r'){
        Clear-Host
        Write-Host "`n`t`t Gestion d'Active Directory`n"
        Write-Host -ForegroundColor Cyan "Gestion d'OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "1"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Creer une OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "2"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Creer une sous-OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "3"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Supprimer une OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "4"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Supprimer une sous-OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "5"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Afficher la liste des objets present dans une OU/CN"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "6"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Afficher la liste des objets present dans une sous_OU"
        $sousmenu1 = Read-Host "`n Selectionner une option [1,2,3] ou ecrire 'R' pour revenir au menu precedent"
       
       
        # Option 1
        if($sousmenu1 -eq 1){
            $name_OU = Read-Host "Quel nom voulez-vous donner à l'OU ? "
            $name_description = Read-Host " Ecrire une description "
            $name_region = Read-Host " Departement ou region "
            $name_ville = Read-Host " Ville "
            $name_adresse = Read-Host " Adresse "

            New-ADOrganizationalUnit -Name $name_OU -Path "dc=formation,dc=lan" -ProtectedFromAccidentalDeletion $true -Description $name_description -State $name_region -City $name_ville -StreetAddress $name_adresse
        }

        # Option 2
        if($sousmenu1 -eq 2){
            $name_dn_OU = read-host " Dans quel OU creer cette sous-OU ?"
            $name_subOU = Read-Host "Quel nom voulez-vous donner à la sous-OU ? "
            $name_description = Read-Host " Ecrire une description "
            $name_region = Read-Host " Departement ou region "
            $name_ville = Read-Host " Ville "
            $name_adresse = Read-Host " Adresse "

            New-ADOrganizationalUnit -Name $name_subOU -Path "ou=$name_dn_OU,dc=formation,dc=lan" -ProtectedFromAccidentalDeletion $true -Description $name_description -State $name_region -City $name_ville -StreetAddress $name_adresse
        }
        
        # Option 3
        if($sousmenu1 -eq 3){
            $name_OU = Read-Host "Quel est le nom de l'OU a supprimer ? "

            Get-ADOrganizationalUnit -Identity "OU=$name_ou,DC=formation,DC=lan" |
            Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru |
            Remove-ADOrganizationalUnit -Confirm:$true -recursive
        }

        # Option 4
        if($sousmenu1 -eq 4){
            $name_sousOU = Read-Host "Quel est le nom de la sous-OU a supprimer ? "
            $name_ou = read-host "De quel OU fait elle partie ? "
            Get-ADOrganizationalUnit -Identity "OU=$name_sousOU,OU=$name_ou,DC=formation,DC=lan" |
            Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru |
            Remove-ADOrganizationalUnit -Confirm:$true -recursive
        }

        # Option 5
        if($sousmenu1 -eq 5){
                                                                                            
            $name_OU = Read-Host "Quel est le nom de l'OU dont vous souhaitez afficher les utilisateurs ? "
            $name_type = Read-Host "Specificier [cn] ou [ou] ? "
            
            Get-ADobject -Filter * -SearchBase "$name_type=$name_OU,dc=formation,dc=lan" | Select-Object name, objectclass | Sort-Object objectclass
        }

        # Option 6
        if($sousmenu1 -eq 6){
                                                                                            
            $name_OU = Read-Host "Quel est le nom de la sous-OU dont vous souhaitez afficher les utilisateurs ? "
            $name_type = Read-Host "Specificier [cn] ou [ou] ? "
            $name_sousOU = Read-host "Quel est le nom de la sous-OU ? "
            
            Get-ADobject -Filter * -SearchBase "OU=$name_sousOU,$name_type=$name_OU,dc=formation,dc=lan" | Select-Object name, objectclass | Sort-Object objectclass
        }
    }
}

function sousmenu2 {
    $sousmenu2 = 'X'
    while($sousmenu2 -ne 'r'){
        Clear-Host
        Write-Host "`n`t`t Gestion d'Active Directory`n"
        Write-Host -ForegroundColor Green "Gestion de Groupe"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "1"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Creer un Groupe"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "2"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Supprimer un Groupe"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "3"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Deplacer un Groupe dans une OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "4"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Afficher la liste des membres du Groupe"
        $sousmenu2 = Read-Host "`n Selectionner une option [1,2,3,4,5,6] ou ecrire 'R' pour revenir au menu precedent"
       
        # Option 1
        if($sousmenu2 -eq 1){
        $name_groupe = Read-Host "Quel nom voulez vous donner au Groupe ? "
        $name_etendue = Read-Host "Choisir l'étendue du Groupe [DomaineLocal]/[Global]/[Universal] ? "
        $name_category = Read-Host "Choisir l'étendue du Groupe [Distribution]/[Security] ? "
        $name_description = Read-Host "Quelle est la description du Groupe ? "
        
        New-ADGroup -Name $name_groupe -Path "cn=users,dc=formation,dc=lan" -GroupScope $name_etendue -GroupCategory $name_category -Description "$name_description"
        }
     
        # Option 2
        if($sousmenu2 -eq 2){
        $name_OU = Read-Host "Quel est le nom du Groupe a supprimer ?(une confirmation est demandee) "
        
        Get-ADOrganizationalUnit -Identity "OU=$name_ou,DC=formation,DC=lan" |
        Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru |
        Remove-ADOrganizationalUnit -Confirm:$true -recursive
        }
     
        # Option 3
        if($sousmenu2 -eq 3){
        $name_groupe = Read-Host "Quel est le nom du Groupe a deplacer ? "
        $name_ou = Read-Host "Dans quelle OU souhaitez mettre ce groupe ? "
        
        Move-ADObject -Identity "CN=$name_groupe,CN=Users,DC=formation,DC=lan" -TargetPath "OU=$name_ou,DC=formation,DC=lan"
        }
      
        # Option 4
        if($sousmenu2 -eq 4){
        $name_groupe = Read-Host "Quel est le nom du Groupe a deplacer ? "
        $name_ou = Read-Host "Dans quelle sous-OU souhaitez mettre ce groupe ? "
        
        Move-ADObject -Identity "CN=$name_groupe,CN=Users,DC=formation,DC=lan" -TargetPath "OU=$name_ou,DC=formation,DC=lan"
        }
     
        # Option 5
        if($sousmenu2 -eq 5){
        $name_groupe = Read-Host "De quel Groupe souhaitez vous en afficher les membres ? "
        
        Get-ADGroupMember -identity "$name_groupe" -Recursive | Get-ADUser -Property DisplayName | Select Name
        }       
    }
}



function sousmenu3 {
    $sousmenu2 = 'X'
    while($sousmenu3 -ne 'r'){
        Clear-Host
        Write-Host "`n`t`t Gestion d'Active Directory`n"
        Write-Host -ForegroundColor Green "Gestion d'utilisateurs"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "1"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Creer un utilisateur"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "2"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Supprimer un utlisateur"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "3"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Deplacer un utilisateur dans une OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "4"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Deplacer un utilisateur dans une sous-OU"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "5"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Ajouter un utilisateur en tant que membre d'un Groupe"
        Write-Host -ForegroundColor DarkCyan -NoNewline "`n["; Write-Host -NoNewline "6"; Write-Host -ForegroundColor DarkCyan -NoNewline "]"; `
            Write-Host -ForegroundColor DarkCyan " Supprimer un utilisateur d'un Groupe"
        $sousmenu2 = Read-Host "`n Selectionner une option [1,2,3,4,5,6] ou ecrire 'R' pour revenir au menu precedent"
       
        # Option 1
        if($sousmenu2 -eq 1){
         $name_user = Read-Host " Quel est le nom de l'user a cree ? "
         $password = Read-Host "mot de passe"
         $city = Read-Host "ville"
         $description = Read-Host "description"
         $bureau = Read-Host "Bureau"

         New-ADUser -Name "$name_user" -SamAccountName $name_user -UserPrincipalName "$name_user" -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) -PasswordNeverExpires $true -CannotChangePassword $true -Enabled $true -City $city -Description $Description -Office $Bureau
        }
    
        # Option 2
        if($sousmenu2 -eq 2){
        $name_OU = Read-Host " Quel est le nom de l'utilisateur a supprimer ? "
        
        Get-ADOrganizationalUnit -Identity "OU=$name_ou,DC=formation,DC=lan" |
        Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru |
        Remove-ADOrganizationalUnit -Confirm:$true -recursive
        }
     
        # Option 3
        if($sousmenu2 -eq 3){
        $name_groupe = Read-Host "Quel est le nom de l'utilisateur a deplacer ? "
        $name_ou = Read-Host "Dans quelle OU souhaitez mettre cet utilisateur ? "
        
        Move-ADObject -Identity "CN=$name_groupe,CN=Users,DC=formation,DC=lan" -TargetPath "OU=$name_ou,DC=formation,DC=lan"
        }

        # Option 4
        if($sousmenu2 -eq 4){
        $name_groupe = Read-Host "Quel est le nom de l'utilisateur a deplacer ? "
        $name_ou1 = Read-Host "Dans quelle OU est il ? "
        $name_sub_dn_ou = Read-Host "Dans quelle sous-OU souhaitez mettre cet utilisateur ? "
        $name_ou = Read-Host "Dans quelle OU cette sous-OU est elle ? "
        
        Move-ADObject -Identity "CN=$name_groupe,OU=$name_ou1,DC=formation,DC=lan" -TargetPath "ou=$name_sub_dn_ou,OU=$name_ou,DC=formation,DC=lan"
        }

        # Option 5
        if($sousmenu2 -eq 5){
        $name_user = Read-Host "Quel est le nom de l'utilisateur a ajouter a un Groupe ? "
        $name_group1 = read-host "Quel est le nom du Groupe dont l'utilisateur etre membre ? "
        
        Add-ADGroupMember -identity "cn=$name_group1,ou=$name_ou,dc=formation,dc=lan" -Members $name_user
        }
             
        # Option 6
        if($sousmenu2 -eq 6){
        $name_OU = Read-Host "Quel est le nom de l'utilisateur a supprimer d'un Groupe ? "
        
        Get-ADUser -Filter * -SearchBase "ou=$name_OU,dc=formation,dc=lan" | Select-Object "name"
        }
    }
}

mainMenu