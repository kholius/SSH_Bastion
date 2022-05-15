#!/bin/bash

######################################## Var

input_prog=$1
input_side=$2

######################################## Functions

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
                for tool in vim tmux cockpit tree python3 open-ssh-server python3-pip screenfetch git nano cmatrix linuxlogo sshpass 
                do

                    $os_package_manager1 install -y $tool 
                    $os_package_manager1 list $tool

                done

                # Specific Tool: Prometeus

}

# Script's Manual / Help
show_help(){

    echo " [Help] "
    sleep 2
    echo "
            Welcome to Hub's script Manual;
    "
    sleep 2
    echo "
            *
            *
            *"
    sleep 1
    echo " [How it works] "
    echo " Some Script, Shell (.sh) based and organized by fall model.
        hub.sh ---> {other_part_of_script}.sh"
    echo " [Dependancies] "
    echo " This programme is delivered with a folder /dep which containe other script. "
    echo "
    SSH-Bastion/
            |   hub.sh
            |   dep/
                    |   basic.sh
                    |   node.sh
                    |   endpoint
                    |   agent
    "
    echo " [Syntax] "
    echo " bash arg1 (arg2 (if needed))
     bash - kind of language (shell)
     arg1 - first input
     arg2 - secondary input "

     echo " Good Luck "
}

###################################### launch by case

case $input_prog in


    basic)

        ls | grep /dep/basic.sh
        cd dep/
        sudo chmod +x basic.sh
        sudo bash basic.sh

    ;;

    bastion)
        # check if the secondary input is empty or not
        #echo $input_side
        if [[ $input_side=="" ]]
        then
            echo " You missed the second argument ! "
            echo " You Have to choose between : node and endpoint "
            sleep 2
            read -p " Wich do you need ? [node or endpoint or exit]" rep_check_2nd_arg

            # check if exit
            if [[$rep_check_2nd_arg=="exit"]]
            then
                echo " Exit soon... "
                exit
            # check if node
            elif [[$rep_check_2nd_arg=="node"]]
            then
                input_side=$rep_check_2nd_arg
            # check if endpoint
            elif [[$rep_check_2nd_arg=="endpoint"]]
            then
                input_side=$rep_check_2nd_arg
            fi

        fi
        # case for launch the second arg for bastion part
        case $input_side in

            node)
                ls | grep /dep/bastion_node.sh
                cd dep/
                sudo chmod +x bastion_node.sh
                sudo bash bastion_node.sh
            ;;

            endpoint)
                ls | grep /dep/bastion_endpoint.sh
                cd dep/
                sudo chmod +x bastion_endpoint.sh
                sudo bash bastion_endpoint.sh
            ;;

        esac

    ;;

    agent)

        sshadd -l
        sshadd
        sshadd -l

    ;;

    h)
        show_help
    ;;

    help)
        show_help
    ;;

esac
