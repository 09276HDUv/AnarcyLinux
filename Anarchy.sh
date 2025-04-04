#!/bin/bash

VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
MAGENTA='\033[0;35m'
CIANO='\033[0;36m'
BRANCO='\033[1;37m'
NC='\033[0m'

mostrar_banner() {
    clear
    echo -e "${MAGENTA}"
    echo "  _  __     _   _                _          _   "
    echo " | |/ /    | | | |              | |        | |  "
    echo " | ' / __ _| |_| |__   __ _ _ __| |__   ___| |_ "
    echo " |  < / _\` | __| '_ \ / _\` | '__| '_ \ / _ \ __|"
    echo " | . \ (_| | |_| | | | (_| | |  | | | |  __/ |_ "
    echo " |_|\_\__,_|\__|_| |_|\__,_|_|  |_| |_|\___|\__|"
    echo "                     ${VERMELHO}B E L L Y${NC}"
    echo -e "${AZUL}=====================================================${NC}"
    echo -e "${CIANO}     Um Arsenal Completo para Termux - by Anarchyms ${NC}"
    echo -e "${AZUL}=====================================================${NC}"
    echo
}

pausar() {
    echo
    read -p " Pressione [Enter] para continuar..."
}

instalar_base() {
    echo -e "${AMARELO}[*] Verificando dependências base...${NC}"
    pkg update -y > /dev/null 2>&1
    pkg upgrade -y > /dev/null 2>&1
    local pkgs_needed=0
    for pkg in git curl wget python python2 nmap coreutils proot openssh; do
        if ! command -v $pkg &> /dev/null; then
            echo -e "${AMARELO}[!] Instalando $pkg...${NC}"
            pkg install $pkg -y > /dev/null 2>&1
            pkgs_needed=1
        fi
    done
    if [ $pkgs_needed -eq 1 ]; then
        echo -e "${VERDE}[+] Dependências base instaladas/atualizadas.${NC}"
        pausar
    fi
}

instalar_vuln_scan() {
    mostrar_banner
    echo -e "${CIANO}[*] Instalando Ferramentas de Scan de Vulnerabilidade...${NC}"
    pkg install nmap sqlmap nikto -y
    echo -e "${VERDE}[+] Nmap, SQLMap, Nikto instalados.${NC}"
    echo -e "${AMARELO}[?] Deseja iniciar um scan Nmap rápido agora? (s/N)${NC}"
    read -p " > " run_nmap
    if [[ "$run_nmap" == "s" || "$run_nmap" == "S" ]]; then
        echo -e "${CIANO} Informe o Alvo (IP ou Domínio):${NC}"
        read -p " > " target
        if [[ -n "$target" ]]; then
            echo -e "${AMARELO}[*] Executando: nmap -T4 -F $target ${NC}"
            nmap -T4 -F $target
        else
            echo -e "${VERMELHO}[!] Alvo inválido.${NC}"
        fi
    fi
    pausar
}

instalar_pentest_framework() {
    mostrar_banner
    echo -e "${CIANO}[*] Instalando Metasploit Framework...${NC}"
    echo -e "${AMARELO}[!] Este processo pode demorar bastante e consumir espaço.${NC}"
    pkg install unstable-repo -y > /dev/null 2>&1
    pkg install metasploit -y
    echo -e "${VERDE}[+] Metasploit Framework instalado (ou tentativa iniciada).${NC}"
    echo -e "${AMARELO}[!] Pode ser necessário executar 'msfconsole' para configuração inicial.${NC}"
    pausar
}

instalar_offline_attacks() {
    mostrar_banner
    echo -e "${CIANO}[*] Instalando Ferramentas de Ataques Offline/Brute Force...${NC}"
    pkg install hydra john-the-ripper hashcat -y
    echo -e "${VERDE}[+] Hydra, John the Ripper, Hashcat instalados.${NC}"
    echo -e "${AMARELO}[!] Hashcat pode requerer configurações adicionais ou não funcionar corretamente dependendo do dispositivo.${NC}"
    pausar
}

instalar_network_tools() {
    mostrar_banner
    echo -e "${CIANO}[*] Instalando Ferramentas de Rede e Análise...${NC}"
    pkg install net-tools inetutils tcpdump hping3 tsu -y
    echo -e "${VERDE}[+] Net-tools, Inetutils, TCPDump, hping3, tsu instalados.${NC}"
    pausar
}

instalar_osint() {
    mostrar_banner
    echo -e "${CIANO}[*] Instalando Ferramentas de Coleta de Informações (OSINT)...${NC}"
    pkg install whois -y
    
    echo -e "${AMARELO}[*] Instalando theHarvester (requer Python)...${NC}"
    pip install theHarvester &> /dev/null
    if ! command -v theHarvester &> /dev/null; then
         echo -e "${VERMELHO}[!] Falha ao instalar theHarvester via pip. Tente 'pip install theHarvester' manualmente.${NC}"
    else
         echo -e "${VERDE}[+] theHarvester instalado.${NC}"
    fi

    echo -e "${AMARELO}[*] Tentando instalar PhoneInfoga (requer git)...${NC}"
    if [ ! -d "PhoneInfoga" ]; then
        git clone https://github.com/sundowndev/PhoneInfoga.git &> /dev/null
        if [ -d "PhoneInfoga" ]; then
             echo -e "${VERDE}[+] PhoneInfoga clonado. Acesse o diretório 'PhoneInfoga' e siga as instruções do README.${NC}"
             echo -e "${AMARELO}   Ex: cd PhoneInfoga && python3 -m pip install -r requirements.txt && python3 phoneinfoga.py -n <numero>${NC}"
        else
             echo -e "${VERMELHO}[!] Falha ao clonar PhoneInfoga.${NC}"
        fi
    else
        echo -e "${AMARELO}[!] Diretório PhoneInfoga já existe.${NC}"
    fi

    echo -e "${VERDE}[+] Whois instalado.${NC}"

    echo -e "${AMARELO}[?] Deseja fazer uma consulta WHOIS agora? (s/N)${NC}"
    read -p " > " run_whois
    if [[ "$run_whois" == "s" || "$run_whois" == "S" ]]; then
        echo -e "${CIANO} Informe o Domínio para consultar:${NC}"
        read -p " > " domain
        if [[ -n "$domain" ]]; then
            echo -e "${AMARELO}[*] Executando: whois $domain ${NC}"
            whois $domain
        else
            echo -e "${VERMELHO}[!] Domínio inválido.${NC}"
        fi
    fi
    pausar
}

instalar_api_test() {
    mostrar_banner
    echo -e "${CIANO}[*] Instalando Ferramentas de Teste de API...${NC}"
    pkg install curl wget jq -y
    echo -e "${VERDE}[+] Curl, Wget, JQ instalados.${NC}"
    echo -e "${AMARELO}[?] Deseja fazer uma requisição GET simples agora? (s/N)${NC}"
    read -p " > " run_curl
    if [[ "$run_curl" == "s" || "$run_curl" == "S" ]]; then
        echo -e "${CIANO} Informe a URL completa:${NC}"
        read -p " > " url
        if [[ -n "$url" ]]; then
            echo -e "${AMARELO}[*] Executando: curl -s -L $url | head -n 10 ${NC}"
            curl -s -L $url | head -n 10
            echo "[...]"
        else
            echo -e "${VERMELHO}[!] URL inválida.${NC}"
        fi
    fi
    pausar
}

instalar_ddos_tools() {
    mostrar_banner
    echo -e "${VERMELHO}[!!!] AVISO EXTREMO [!!!]${NC}"
    echo -e "${VERMELHO}Ataques de Negação de Serviço (DDoS) são ${BRANCO}ILEGAIS${VERMELHO} na maioria das jurisdições."
    echo -e "Usar estas ferramentas contra sistemas sem autorização explícita"
    echo -e "pode resultar em consequências legais ${BRANCO}SEVERAS${VERMELHO}."
    echo -e "Use apenas em redes e sistemas ${BRANCO}PRÓPRIOS${VERMELHO} ou com permissão documentada."
    echo -e "${AMARELO}Você entende os riscos e assume TOTAL responsabilidade? (s/N)${NC}"
    read -p " > " confirm_ddos
    if [[ "$confirm_ddos" != "s" && "$confirm_ddos" != "S" ]]; then
        echo -e "${VERMELHO}[!] Instalação cancelada.${NC}"
        pausar
        return
    fi
    echo -e "${CIANO}[*] Instalando Ferramentas que podem ser usadas para DDoS...${NC}"
    pkg install hping3 torsocks -y
    
     echo -e "${AMARELO}[*] Tentando instalar Slowloris (requer git)...${NC}"
    if [ ! -d "slowloris" ]; then
        git clone https://github.com/gkbrk/slowloris.git &> /dev/null
        if [ -d "slowloris" ]; then
             echo -e "${VERDE}[+] Slowloris clonado. Acesse o diretório 'slowloris'.${NC}"
             echo -e "${AMARELO}   Ex: cd slowloris && python slowloris.py <alvo>${NC}"
        else
             echo -e "${VERMELHO}[!] Falha ao clonar Slowloris.${NC}"
        fi
    else
        echo -e "${AMARELO}[!] Diretório slowloris já existe.${NC}"
    fi
    echo -e "${VERDE}[+] Hping3, Torsocks instalados.${NC}"
    pausar
}

instalar_tudo() {
    mostrar_banner
    echo -e "${AMARELO}[*] Iniciando instalação completa... Isso pode levar MUITO tempo!${NC}"
    pausar
    instalar_vuln_scan
    instalar_pentest_framework
    instalar_offline_attacks
    instalar_network_tools
    instalar_osint
    instalar_api_test
    instalar_ddos_tools
    echo -e "${VERDE}[+++] Instalação completa (ou tentativas) concluída! [+++]${NC}"
    pausar
}

atualizar_sistema() {
    mostrar_banner
    echo -e "${CIANO}[*] Atualizando sistema e pacotes Termux...${NC}"
    pkg update -y
    pkg upgrade -y
    echo -e "${VERDE}[+] Sistema atualizado.${NC}"
    pausar
}

instalar_base

while true; do
    mostrar_banner
    echo -e " ${BRANCO}Selecione uma Opção de Instalação:${NC}"
    echo -e " ${AZUL}-----------------------------------${NC}"
    echo -e " [${VERDE}1${NC}] ${CIANO}Scanner de Vulnerabilidades${NC} (Nmap, SQLMap, Nikto)"
    echo -e " [${VERDE}2${NC}] ${CIANO}Pentest Framework${NC} (Metasploit)"
    echo -e " [${VERDE}3${NC}] ${CIANO}Ataques Offline/Brute${NC} (Hydra, John, Hashcat)"
    echo -e " [${VERDE}4${NC}] ${CIANO}Ferramentas de Rede${NC} (TCPDump, Hping3, Net-Utils)"
    echo -e " [${VERDE}5${NC}] ${CIANO}OSINT & Coleta Dados${NC} (Whois, TheHarvester, PhoneInfoga*)"
    echo -e " [${VERDE}6${NC}] ${CIANO}Teste de API${NC} (Curl, Wget, JQ)"
    echo -e " [${VERDE}7${NC}] ${VERMELHO}Ferramentas de Ataque${NC} (Hping3, Slowloris*, Torsocks) ${BRANCO}[CUIDADO]${NC}"
    echo -e " ${AZUL}-----------------------------------${NC}"
    echo -e " [${VERDE}8${NC}] ${AMARELO}INSTALAR TUDO${NC} (Pode demorar!)"
    echo -e " [${VERDE}9${NC}] ${AMARELO}Atualizar Sistema e Ferramentas Base${NC}"
    echo -e " [${VERMELHO}0${NC}] ${BRANCO}Sair${NC}"
    echo -e " ${AZUL}-----------------------------------${NC}"
    echo -e "${AMARELO}* Requer instalação/configuração adicional.${NC}"
    echo

    read -p " KAB> " choice

    case $choice in
        1) instalar_vuln_scan ;;
        2) instalar_pentest_framework ;;
        3) instalar_offline_attacks ;;
        4) instalar_network_tools ;;
        5) instalar_osint ;;
        6) instalar_api_test ;;
        7) instalar_ddos_tools ;;
        8) instalar_tudo ;;
        9) atualizar_sistema ;;
        0) echo -e "${BRANCO}Saindo...${NC}"; break ;;
        *) echo -e "${VERMELHO}[!] Opção inválida!${NC}"; pausar ;;
    esac
done

exit 0
