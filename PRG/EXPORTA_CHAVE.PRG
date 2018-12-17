DO WDIR+"\Linx\Chave\geralogchave.FXP"
DO WDIR+"\Linx\Chave\leituralog.FXP"


xArq=PUTFILE('Arquivo:','','xls')
xArq=STRTRAN(xArq,' ','_')

COPY TO &xArq xls