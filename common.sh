
set -e 

failure(){
    echo "Error occured at $1, Error Command:$2"
}

trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

userid=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d '.' -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
# echo "Enter the Password"
# read mysql_root_Password

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2..$R is Failure $N"
    else
        echo -e "$2..$G is Success $N"
    fi
}

check_root(){
    if [ $? -ne 0 ]
    then 
        echo "You're not a Superuser"
        exit 1
    else    
        echo "You're a Superuser"
    fi
    }