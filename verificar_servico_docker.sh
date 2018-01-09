# Proposito:    Verificar se o serviço docker esta UP
#               - Se não estiver, iniciar o serviço docker
#
# Utilização:   ./script.sh
# Exemplo:      ./verificar_servico_docker.sh
# autor:        William Santos
# data:         2018-01-06
# -------------------------------------------------------------------------------------------------
# VARIAVEIS DE AMBIENTE
# -------------------------------------------------------------------------------------------------

DT_LOG=`date '+%Y%m%d%H%M%S'`
SCRIPT_NAME=`basename $0`
WORKSPACE=`pwd`
DIR_DMP="${WORKSPACE}/DMP"
DIR_LOG="${WORKSPACE}/LOG"
DIR_TMP="${WORKSPACE}/TMP"
mkdir -p $DIR_DMP $DIR_LOG $DIR_TMP
LOGFILE=${WORKSPACE}/LOG/${DT_LOG}_${SCRIPT_NAME%.sh}.log
SERVER=`uname -a | cut -d' ' -f2 | cut -f1 -d'.'`
DIA=`date '+%Y%m%d'`
DATE=`date '+%Y%m%d%H%M%S'`

# -------------------------------------------------------------------------------------------------
# CARREGAR FUNÇÕES
# -------------------------------------------------------------------------------------------------

source ${WORKSPACE}/funcoes.sh

# -------------------------------------------------------------------------------------------------
# INICIO
# -------------------------------------------------------------------------------------------------

log_div "D:"
log_msg "I: INÍCIO - ${SCRIPT_NAME}"

# -------------------------------------------------------------------------------------------------
# VERIFICAR SE O CONTANINER ESTA UP
# -------------------------------------------------------------------------------------------------

log_msg "I: Verificar se o SERVIÇO DOCKER esta UP"

systemctl status docker.service -l | grep "is not running"
if [ $? -eq 0 ]; then
   {
      log_msg "E: STATUS:"
      systemctl status docker.service -l > ${DIR_TMP}/arquivo.tmp 2> ${DIR_TMP}/arquivo.tmp
      cat ${DIR_TMP}/arquivo.tmp | while read LIN; do log_msg "E: - $LIN" ; done
      log_msg "E: RESTART:"
         systemctl stop docker.service
         systemctl start docker.service
      log_msg "I: STATUS:"
      systemctl status docker.service -l > ${DIR_TMP}/arquivo.tmp 2> ${DIR_TMP}/arquivo.tmp
      cat ${DIR_TMP}/arquivo.tmp | while read LIN; do log_msg "I: - $LIN" ; done
   }
else
   {
      log_msg "I: STATUS:"
      systemctl status docker.service -l > ${DIR_TMP}/arquivo.tmp 2> ${DIR_TMP}/arquivo.tmp
      cat ${DIR_TMP}/arquivo.tmp | while read LIN; do log_msg "I: - $LIN" ; done
   }
fi

# -------------------------------------------------------------------------------------------------
# FIM
# -------------------------------------------------------------------------------------------------

log_msg "I: FIM - ${SCRIPT_NAME}"
log_div "D:"

# -------------------------------------------------------------------------------------------------

exit 0
