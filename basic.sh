#!/bin/bash


echo "
Welcome to the basic.sh script;
wich provide a basic setting for your server.

"


############################ Schedule

# wich os 
# check internet

# Basic Settings
    # Update
    # Ip
    # Basic tools
        # vim
        # tmux
        # netplan.io
        # cockpit
        # tree
        # python3
        # cmatrix
        # open-ssh-server
        # Prometeus [ work in progress ]
    # add mdp for root
    # Update

# Call to Action [pass or reboot or shutdown]



##################################### functions

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

                https_rapport=$(cat https_result.txt)
                icmp_rapport=$(cat icmp_result.txt)
}


            ############ PSWD_ROOT ###########
# Get the password for root
pswd_root_info00(){
                read -p " Which password would you apply to Root Account? Take Care about the stenght of it." root_pswd   
}

# Apply Password of root profile
pswd_root_apply00(){
                echo root:$root_pswd | chpasswd
                sudo cat /etc/shadow | grep root

                root_pswd="0"
}


            ########### IP ############
# Get IP fix
ip_fix_info00(){
# Display Info
                ip addr
                ip route

                # Set var with Questtxtns
                echo " Well, it's time to set up your Network Interface " 
                echo " [ Take care how your input done ] "
                read -p " Wich Interface would you set ? : " int_
                read -p " and Wich IP? : " ip_
                read -p " well and your netmask? [CIDR]" msk_
                read -p " By wich gateway [GTW]" gtw_
                read -p " Have you a DNS? " nemsrv_
                read -p " Wich status $int_ must have ? [ up / down ] " status_


                # Loop for status_
                # up or down  - Ok
                # empty or other - by default Up
                if [[ $status_ = "up" ]]
                then
                    echo " UP "

                elif [[ $status_ = "down" ]]
                then
                    echo " Down "

                elif  [[ -z $status_ ]]
                then
                    echo " Default status: Up "
                    status_="up"

                else
                    echo " Default status: Up "
                    status_="up"

                fi

}

# Apply IP six
ip_fix_apply00(){
                # Display ALL conf Int and Routes
                # ifconfig -s
                # route
                ip addr | grep $int_
                ip route

                # Setting IP fix and Add route
                # ifconfig -v $int_ $ip_ netmask $msk_ $status_ # ifconfig  -v ens33 192.168.1.199 netmask 255.255.255.0 up
                # route add $gtw_ $int # route add default 192.168.1.240 ens33
                ip link set $int_ $status_ # set the status 
                ip addr add $ip_/$msk_ dev $int_ # apply IP addr/cidr on a nic
                ip route add $gtw_/$msk_ dev $int # apply GTW on a nic
                echo "nameserver $nemsrv_" >> /etc/resolv.conf


                echo "
                
                
                
                
                
                    "
                sleep 10
                # Get Output for Rapport
                # ifconfig $int_ | grep inet > result_change_ip.txt
                # route | grep $int > result_gtw_for_int.txt
                ip addr | grep inet 
                ip route | grep $int_ 
                
                # Print Result to User
                sleep 5

                ip addr | grep $int_ 
                ip route
                systemd-resolve --status | grep 'DNS Servers' -A5

                echo " Change Apply... "
                # route | grep $int_
                sleep 5
                # ifconfig $int_
                echo " ...Done "

}


            ########### PKG MGMT ###########
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

# Install Basic Tools
Basic_Tools00(){
                echo $os_package_manager1
                # Tools via apt 
                # For each tool in the list, you install and check the package list
                for tool in vim tmux netplan.io cockpit tree python3 open-ssh-server python3-pip screenfetch git nano cmatrix linuxlogo sshpass
                do

                    $os_package_manager1 install -y $tool 
                    $os_package_manager1 list $tool

                done

                # Specific Tool: Prometeus

}

##################################### Applyment ######################################

#1
check_os_package_manager00
check_internet

sleep 5

#2
ip_fix_info00
pswd_root_info00

#3
ip_fix_apply00
pswd_root_apply00
update00
Basic_Tools00
update00

