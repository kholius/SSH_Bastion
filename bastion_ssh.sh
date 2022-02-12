#!/bin/bash

############################ Schedule

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
        # open-ssh-server
        # Prometeus [ work in progress ]
    # add mdp for root
    #


# Set part
    # 1 > Bastion set side
    # 2 > Endpoint set side
    # 3 > Bastion set launch



# Bastion set side
    # Setting everything for a bastion 
    # check internet
    # catch the openssh package
    # create a spécific ssh profile or not
        # key gen
        # key copy id
    # update host file if there is not DNS
    # create an ECDSA key on the ssh profile
    # modify pam.d if needed
    # create an config file in /home/.ssh/
    # add on the crontab " creation of ssh-agent "



# Endpoint set side
    # Setting everything for a bastion 
    # check internet
    # catch the openssh package
    # create a spécific ssh profile or not
    # pam.d
    # 
    # allow / deny file

# Bastion set launch
    # creation of ssh agent if needed
        # sshadd -l
        # sshadd
        # sshadd -l






############################ Intro
############################ Constants
############################ Var 
############################ Function
############################ Select part
    ############################ Getting Infos
############################ Applying


#////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

############################ Intro
############################ Constants
val=" -y"
root_pswd="0"
set_part_answer=0
############################ Var 



############################ Function

        ############################ Core Function
            ################################### Get Information
            
            # Set part 
            set_part(){

                read -p " Which part would you want set? 1: Bastion Set; 2: Endpoint Set; 3: Bastion launch " set_part_answer

                if [[ $set_part_answer -eq 1 ]]
                then
                    echo "part 1"
                    
                    # Launch Ask Function 
                    # $set_part_answer will condition the part Ask Function used
                    Ask

                elif [[ $set_part_answer -eq 2 ]]
                then
                    echo "part 2"
                elif [[ $set_part_answer -eq 3 ]]
                then
                    echo "part 3"
                else
                    echo "no part"
                fi
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

                https_rapport=$(cat https_result.txt)
                icmp_rapport=$(cat icmp_result.txt)


            }


            ################# # Get Info Part 1

            # Get Password of root profile
            # used in Ask Function
            pswd_root_info00(){

                read -p " Which password would you apply to Root Account? Take Care about the stenght of it." root_pswd   

            }
            
            # Get IP fix
            # used in Ask Function
            ip_fix_info00(){
                
                # Display Info
                # sudo $os_package_manager install net-tools -y 
                # ifconfig -s 
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

            ################# # Get Info Part 2

            ssh_profile(){


                # need a ssh profile? y n > bastion_ask
                if [[ $need_of_ssh_config_answer=="y" ]]
                then
                    # y
                    # which name ?
                    read -p " Which profile do you want set ? " name_to_check
                        # check if the name exist (with home dir)
                        check1=$(ls /home/ | grep $name_to_check | echo $?)
                        #check2=$()
                            # if exist 
                            if [[ $check1 -eq 0 ]]
                            then

                                user00=$name_to_check 
                                
                                # creation of ECDSA key in the home/[name_user]/.ssh
                                mkdir /home/$user00/.ssh | grep /home/$user00/.ssh
                                ssh-keygen -t ecdsa -b 521 -f /home/$user00/.ssh/bastion-key-00
                                
                                # show our keys 
                                cat /home/$user00/.ssh/bastion-key-00
                                cat /home/$user00/.ssh/bastion-key-00.pub 

                                # do we need to add some host ? y n
                                
                                    # y
                                            # how many ?
                                                # until $num
                                                    # which addr need we add [ or name ] ?
                                                        # creation of array [array_name=()]
                                                        # add answer on a array [ array_name+=("$addr")]
                                    # n
                                        # pass
                            # if don't exists
                            elif [[ $check1 -eq 0 ]]
                            then
                                    # creation of profile
                                        # name ?
                                        # password ?
                                            # check
                                        # creation of ECDSA key in the home/[name_user]/.ssh
                                        # do we need to add some host ? y n
                                            # y
                                                # how many ?
                                                    # until $num
                                                        # which addr need we add [ or name ] ?
                                                            # creation of array [array_name=()]
                                                            # add answer on a array [ array_name+=("$addr")]
                                            # n
                                                # pass
                            else
                              
                                echo " [OOBE] "
                            
                            fi
                elif [[ $need_of_ssh_config_answer=="n" ]]
                then
                    # n
                        # pass
                

                else

                    echo " [OOBE] "

                fi
            
            # apply ssh-copy-id # ???


            }

            #ssh_conf_info(){
                # ask information for every kind of argument and put each on var
            #}

            #ssh_conf_apply(){
                # apply every arg from ssh_conf_info
            #}

            host_file(){
                # add host to hosts file
                # or 
                # check/set a DNS serv
            }

            pam_set(){
                # set the deamon of authentification + autho
                # set /etc/pam.d
            }

            cron_ssh_agent(){}


            ###### Get information
            Ask(){
                
                # with the var $set_part_answer the script will lauch a function for get informations
                # if 1
                if [[ $set_part_answer -eq 1 ]]
                then

                    basic_ask(){
                    
                        # ask if it needed to set the root password
                        read -p " Do you need to set a new password for root user ? [y/n]  " root_pswd_answer
                        

                    #########################################################################
                    
                    # ask informations for IP addr
                    ip_fix_info00
                    
                    }

                basic_ask

                bastion_ask(){
                        # need ssh conf?
                        read -p " Do you need to configure a SSH config ? [y/n] : " need_of_ssh_config_answer
                        case $need_of_ssh_config_answer in
                            y)
                                echo "[Let's set the SSH profile.] "
                                ssh_profile
                                ;;
                            n)
                                echo "[OK no SSH profile...]"
                                sleep 5
                                ;;
                            *)
                                echo " [OOBE] "
                        esac
                        # need hosts file modification?
                        # right pam.d? 
                    }

                # if 2
                elif [[ $set_part_answer -eq 2 ]]
                then
                
                    echo "part 2"
                    
                # if 3
                elif [[ $set_part_answer -eq 3 ]]
                then

                    echo "part 3"

                else

                    echo "OOBE"

                fi
            }

            ################################## Apply Information

            # Apply Password of root profile
            pswd_root_apply00(){
                

                echo root:$root_pswd | chpasswd
                sudo cat /etc/shadow | grep root

                root_pswd="0"

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
                    
                    os_package_manager1="yum"

                elif [[ $os_distrib=="Fedora" ]]
                then
                
                    os_package_manager1="yum "

                elif [[ $os_distrib=="Oracle Linux Server" ]]
                then
                
                    os_package_manager1="yum"

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
                for tool in vim tmux netplan.io cockpit tree python3 open-ssh-server python3-pip screenfetch git nano 
                do

                    $os_package_manager1 install $tool $val
                    $os_package_manager1 list $tool

                done

                # Specific Tool: Prometeus

            }


        ########################### Layer Function

            


            # Basic Settings
            Basic01(){
                # Update
                update00
                # Ip
                ip_fix_apply00
                # Basic tools
                    # vim
                    # tmux
                    # netplan.io
                    # cockpit
                    # tree 
                    # python3
                    # open-ssh-server
                    # Prometeus [ work in progress ]
                Basic_Tools00
                # add mdp for root
                if [[ $root_pswd_answer = "y" ]]
                then
                    echo " [ Set new root password ]  "
                    sleep 2
                    # Get information and modify it
                    pswd_root_info00
                    sleep 3
                    pswd_root_apply00

                elif [[ $root_pswd_answer = "n" ]]
                then
                    echo " [ No modification of root password ] "
                    # Pass it
                    sleep 3
                else
                    echo "pass"
                fi
                #
            }


            # Bastion Side Settings
            Bastion_set_side(){
                # Bastion set side
                # Setting everything for a bastion 
                    # check internet
                    check_internet
                        # $internet_stat=0 -- OK  100  -- KO

                    # catch the openssh package
                    sudo $os_package_manager1 list open-ssh-server
                    # create a spécific ssh profile or not
                        # key gen
                        # key copy id

                    # update host file if there is not DNS
                    # create an ECDSA key on the ssh profile
                    # modify pam.d if needed
                    # create an config file in /home/.ssh/
                    # add on the crontab " creation of ssh-agent "

            }





################## Script
# set package manager [apt or yum]
check_os_package_manager00


set_part

# Ask informations
#Ask


#Basic01



# End Function
# It will be launch after every getting information
Applying_Script(){

    if [[ $set_part_answer -eq 1 ]]
    then
        echo " part 1 "
        echo " Bastion Set Side "
        
        echo " Basic setting Inbound "
        Basic01
        
        echo " Bastion Setting Inbound "


    elif [[ $set_part_answer -eq 2 ]]
    then
        
        echo "part 2"

    elif [[ $set_part_answer -eq 3 ]]
    then

        echo "part 3"

    else

        echo "OOBE Applying"

    fi

    }


Applying_Script