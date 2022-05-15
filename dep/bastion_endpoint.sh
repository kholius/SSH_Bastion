#!/bin/bash


# Endpoint set side
    # Setting everything for a bastion 
    # check internet
    # catch the openssh package
    # create a spécific ssh profile or not
    # pam.d
    # allow / deny file

################################# Functions

# Package Manager
check_os_package_manager00(){
                
                # get os_based ID and manipulate string 
                # os-release is available on every distib
                # lsb-release isn't available on RPM based OS 

                cat /etc/os-release | grep NAME= -m 1
                cat /etc/os-release | grep NAME= -m 1 > os.txt
                sed -i "s/NAME=//g" os.txt
                sed -i 's/"//g' os.txt

                #cat /etc/lsb-release | grep DISTRIB_ID= -m 1
                #cat /etc/lsb-release | grep DISTRIB_ID= -m 1 > os.txt
                #sed -i "s/DISTRIB_ID=//g" os.txt
                #sed -i 's/"//g' os.txt
                
                #cat os.txt content in a var
                os_distrib=$(cat os.txt)
                echo $os_distrib

                # set the os_package_manager
                if [[ $os_distrib=="UBUNTU" ]]
                then

                    os_package_manager1="apt "

                elif [[ $os_distrib=="Debian GNU/Linux" ]]
                then

                    os_package_manager1="apt "

                elif [[ $os_distrib="VMware Photon OS" ]]
                then
                    
                    os_package_manager1="yum "

                elif [[ $os_distrib=="Fedora" ]]
                then
                
                    os_package_manager1="yum "

                elif [[ $os_distrib=="Oracle Linux Server" ]]
                then
                
                    os_package_manager1="yum "

                elif [[ $os_distrib=="Red Hat Enterprise Linux" ]]
                then

                    os_package_manager1="yum "
                
                elif [[ $os_distrib=="Rocky Linux" ]]
                then

                    os_package_manager1="yum "
                
                else

                    echo " OOBE Package "

                fi

                echo $os_package_manager1


}

# Do updates
update00(){
                sudo $os_package_manager1 list --upgradable

                sudo $os_package_manager1 update -y && sudo $os_package_manager1 upgrade -y 

                sudo $os_package_manager1 list --upgradable
}

# Check Internet
check_internet(){
     
                # ping test with 5 request 
                echo " Checking Internet "
                ping 8.8.8.8 -c 5
                echo $?
                # the ping's result make a statement 0 = Ok ; 1 = Error ; OOBE 
                if [[ $? -eq 0 ]]
                then
                    echo " Ping -OK "
                    echo " Let's try a HTTPS request "
                    icmp_stat=0

                    if nc -zw1 google.com 443
                    then
                        
                        https_stat=0
                        echo " Your Internet access is OK "
                        internet_stat=0
                        echo $internet_stat
                        echo $https_stat > https_result.txt

                    else

                        https_stat=1
                        echo " HTTPS request failed "
                        internet_stat=100
                        echo $https_stat > https_result.txt

                    fi

                elif [[ $? -eq 1 ]]
                then

                    echo " Your Internet access is unusual "
                    internet_stat=100
                    echo $internet_stat
                    icmp_stat=1
                    echo $icmp_stat > icmp_result.txt

                    echo " Maybe ICMP:8 is denied... "
                    echo " Right, let's try a HTTPS request "
                    if nc -zw1 google.com 443
                    then
                        
                        echo " Your Internet access is OK "
                        https_stat=0
                        internet_stat=0
                        echo $internet_stat
                        echo $https_stat > https_result.txt
                    
                    else

                        https_stat=1
                        echo " HTTPS request failed "
                        echo $https_stat > https_result.txt
                        internet_stat=100
                        
                    fi
                else

                echo "[[ OOBE ]]"
                internet_stat=50
                icmp_stat=2
                https_stat=2

                echo $icmp_stat > icmp_result.txt
                echo $https_stat > https_result.txt
                fi

                # take acttxtn if there is no internet connextxtn or OOBE
                if [[ $internet_stat -eq 100 ]]
                then
                    echo " WARNING, No Internet Connextxtn "
                    echo " Script will go down "
                    sleep 10

                    # exit from script
                    exit

                elif [[ $internet_stat -eq 50 ]]
                then
                    echo " OOBE "
                    echo " Reboot Inbound "
                    sleep 8

                    # reboot
                    reboot

                else
                
                echo " OOBE "
                fi

                #https_rapport=$(cat https_result.txt)
                #icmp_rapport=$(cat icmp_result.txt)
}

# check SSH pkg
check_ssh(){

    systemctl status sshd | grep running
    if [[ $? -eq 0 ]]
    then
        
        echo " SSH's deamon is OK and Run "

    elif [[ $? -eq 1 ]]
    then
    fi
}