#include "totvs.ch"

function u_niversAdvPL()
local i := 0       
local tempPath := GetTempPath()
local aButtons := {;
					"nivers_cake-variant",;
					"nivers_home",;
                    "nivers_delete-forever",;
                    "nivers_device_hub",;
                    "nivers_menu";
                  } // BOTOES DEVEM ESTAR COMPILADOS COMO RECURSO  
private OS := getOS() // Recupera sistema operacional em execucao

oDlg := TWindow():New(10, 10, 800, 600, "Nivers AdvPL")
oDlg:setCss('QPushButton{borde: 1px solid black}')

    // Baixa botoes do RPO no TEMP
	for i := 1 to len(aButtons)
		cFile :=  + aButtons[i]+'.png'
		cFileContent := getApoRes(cFile)

		if cFileContent == Nil
			msgAlert("Botao: " + cFile + " nao existe no RPO, favor compilar o arquivo")
			return
		else
			if OS == "UNIX"
				cFileDownload := "l:" + tempPath + cFile
			else
				cFileDownload := tempPath+cFile
			endif
			
			nHandle := fCreate(cFileDownload)
			fWrite(nHandle, cFileContent)
			fClose(nHandle)
		endif
    next i    
        
	// [*AppBar]
	oTBar := TBar():New( oDlg, 25, 32, .T.,,,, .F. )
	oTBar:SetCss("QFrame{background-color: #007bff;}")
    oBtn1 := TButton():New(0,0,"",oTBar,{|| }, 12,12,,,.F.,.T.,.F.,,.F.,,,.F. )
    oBtn2 := TButton():New(0,0,"",oTBar,{|| home() }, 12,12,,,.F.,.T.,.F.,"Home",.F.,,,.F. )
    oBtn3 := TButton():New(0,0,"",oTBar,{|| nivers() }, 12,12,,,.F.,.T.,.F.,"Aniversários",.F.,,,.F. )
	oBtn4 := TButton():New(0,0,"",oTBar,{|| hooks() }, 12,12,,,.F.,.T.,.F.,"Hooks",.F.,,,.F. )
	
	// [*StyleSheet] Estiliza os botoes da barra superior
	cCss := ("QPushButton{ qproperty-iconSize: 24px;"+;
			" qproperty-icon: url(<image>); background-color: transparent;}"+;
			"QPushButton:hover{background-color: #0069d9; border: none;}")    
	
	// No caso do oBtn1 temos que "esconder" o indicador de menu, ou a visualização ficara prejudicada
	oBtn1:SetCss(StrTran(cCss, "<image>", "/tmp/nivers_menu.png")+;
							   "QPushButton::menu-indicator{position: relative; top: -20px;}")
    oBtn2:SetCss(StrTran(cCss, "<image>", "/tmp/nivers_home.png"))
    oBtn3:SetCss(StrTran(cCss, "<image>", "/tmp/nivers_cake-variant"))
    oBtn4:SetCss(StrTran(cCss, "<image>", "/tmp/nivers_device_hub"))

	// [*MainMenu]
    oMenu := TMenu():New(0,0,0,0,.T.)
    oTMenuIte1 := TMenuItem():New(oDlg,"Home",,,,{|| home() },,,,,,,,,.T.)
    oTMenuIte2 := TMenuItem():New(oDlg,"Aniversarios",,,,{|| nivers() },,,,,,,,,.T.)
    oTMenuIte3 := TMenuItem():New(oDlg,"Hooks",,,,{|| hooks() },,,,,,,,,.T.)
    oMenu:Add(oTMenuIte1)
    oMenu:Add(oTMenuIte2)
    oMenu:Add(oTMenuIte3)
	oBtn1:SetPopupMenu(oMenu)
	
	// [*Router] - No AdvPL não temos roteamento, as subrotinas sao abertas em Dialogs

oDlg:Activate("MAXIMIZED")
return nil

// ---------------------------------------------------------------
// Retorna SO do Smartclient
// ---------------------------------------------------------------
static function getOS()
local stringOS := Upper(GetRmtInfo()[2])

	if ("ANDROID" $ stringOS)
    	return "ANDROID" 
	elseif ("IPHONEOS" $ stringOS)
		return "IPHONEOS"
	elseif GetRemoteType() == 0 .or. GetRemoteType() == 1
		return "WINDOWS"
	elseif GetRemoteType() == 2 
		return "UNIX" // Linux ou MacOS		
	elseif GetRemoteType() == 5 
		return "HTML" // Smartclient HTML		
	endif
	
return ""

// ---------------------------------------------------------------
static function home()
// ---------------------------------------------------------------
Local oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Local oSay1

	DEFINE MSDIALOG oDlg TITLE "Home" FROM 000, 000  TO 100, 300 COLORS 0, 16777215 PIXEL
@ 009, 004 SAY oSay1 PROMPT "Tela inicial do App" SIZE 200, 017 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
  	ACTIVATE MSDIALOG oDlg CENTERED
return	

// ---------------------------------------------------------------
static function hooks()
// ---------------------------------------------------------------
Local oButton1
Local oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Local oSay1
Local nCount := 0
Local cClicksIni := "Voce clicou {{count}} vezes"

	// Parser inicial
	cClicks := StrTran(cClicksIni, "{{count}}", cValToChar(nCount))

  	DEFINE MSDIALOG oDlg TITLE "Hooks" FROM 000, 000  TO 100, 300 COLORS 0, 16777215 PIXEL
    	@ 009, 004 SAY oSay1 PROMPT cClicks SIZE 165, 017 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    	@ 032, 004 BUTTON oButton1 PROMPT "Incrementa contador - Por referencia" SIZE 100, 012 OF oDlg PIXEL Action {|| hooksINC(oSay1, @nCount, cClicksIni) }
  	ACTIVATE MSDIALOG oDlg CENTERED

Return

// ---------------------------------------------------------------
static function hooksINC(oSay1, nCount, cClicksIni)
// ---------------------------------------------------------------
	nCount++ // [*Getter_and_Setter] Incrementa contador
	oSay1:setText( StrTran(cClicksIni, "{{count}}", cValToChar(nCount)) )
return	

// ---------------------------------------------------------------
static function nivers()
// ---------------------------------------------------------------
Local oButton1
Local oGet1
Local oGet2
Local cAniversariante := Space(100) // [*InputParams]
Local dNiver := Date()
Local oMultiGe1
Local cMultiGe1 := ""
Local oSay1
Local oSay2
Static oDlg

  // [*Form] - Formulario para inclusao dos aniversarios
  DEFINE MSDIALOG oDlg TITLE "Nivers" FROM 000, 000  TO 320, 500 COLORS 0, 16777215 PIXEL

	@ 014, 145 BUTTON oButton1 PROMPT "INSERIR" SIZE 054, 012 OF oDlg PIXEL Action {|| NiversInsert(oMultiGe1, cAniversariante, dNiver) }
	
	/* [*CustomButton] Definicao do CSS */
	oButton1:SetCss(;
		"QPushButton {"+;
    	"	border: none;"+;
    	"	color: #fff;"+;
    	"	background-color: #007bff;}"+;
		"QPushButton:hover {"+;
    	"	background-color: #0069d9;}")

    @ 004, 004 SAY oSay1 PROMPT "Aniversariante" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 004, 079 SAY oSay2 PROMPT "Niver" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014, 003 MSGET oGet1 VAR cAniversariante SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 014, 078 MSGET oGet2 VAR dNiver SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 004 GET oMultiGe1 VAR cMultiGe1 OF oDlg MULTILINE SIZE 236, 120 COLORS 0, 16777215 HSCROLL PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

// ---------------------------------------------------------------
static function niversInsert(oMultiGe1, cAniversariante, dNiver)
// ---------------------------------------------------------------
	// [*Submit] Insere aniversarios na lista
	oMultiGe1:appendText(chr(10) + trim(cAniversariante) +" | "+ DtoC(dNiver))
return