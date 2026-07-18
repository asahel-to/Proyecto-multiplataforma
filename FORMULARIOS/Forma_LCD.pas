unit Forma_LCD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls , ShellAPI, MMSystem;

type
  TFormaLCD = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    editPrograma: TEdit;
    memoAsm: TMemo;
    Label2: TLabel;
    editText: TEdit;
    btnExportar: TButton;
    Image3: TImage;
    laHora: TLabel;
    btnCerrar: TButton;
    procedure btnCerrarClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);

    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    emu86, enter, APOSTROFE, INICIO, FIN, programa: string;
    Archivo:TextFile;
    prog,mensaje:String;
  end;

var
  FormaLCD: TFormaLCD;

implementation

{$R *.dfm}

procedure TFormaLCD.btnCerrarClick(Sender: TObject);
begin
 close;
end;

procedure TFormaLCD.btnExportarClick(Sender: TObject);
begin
    try

      prog:='C:\Users\asahe\Downloads\' + editPrograma.Text+ '.asm';
      mensaje:=editText.Text;
        IF((length(prog)<>0) AND (length(mensaje)<>0)) THEN
        BEGIN
            emu86:= '.MODEL SMALL'+ ENTER+
            '.STACK'+ ENTER+
            '.DATA'+ ENTER+
            '.CADENA DB '+ APOSTROFE+
             editText.Text+APOSTROFE+ENTER+
            '.CODE'+ENTER+ENTER+
            INICIO  +ENTER+ENTER+
            'MOV DX,2040H' +ENTER+
            'MOVI SI,0'+ENTER+
            'MOV AL,CADENA[SI]'+ENTER+
            'OUT DX,AL'  +ENTER+FIN;

            AssignFile(Archivo,prog);
            Rewrite(Archivo);
            Write(Archivo,emu86);
            laHora.Caption:='Hora de envio'+ TimeToStr(now);
            sndPlaySound('C:\Users\asahe\OneDrive\Documentos\LyA2\PORYECTO HIBRODO MULTIPLATAFORMA\SONIDO\new-notification-022-370046.wav', SND_FILENAME or SND_ASYNC);
            closeFile(Archivo);
            MemoASM.Lines.LoadFromFile(Prog);

            ShellExecute(FormaLCD.handle,nil,pChar(prog),nil,nil,SW_SHOWNORMAL)

        END
        ELSE
        BEGIN
            ShowMessage('Favor de proporcionar datos');
        END;




    except
        showMessage('error al generar el archivo LCD .asm')
    end;  //fin try
end;


procedure TFormaLCD.FormActivate(Sender: TObject);
begin
    enter    := #13#10;
    APOSTROFE := '''';
    INICIO    := 'MOV AX,@DATA' + ENTER +
                 'MOV DS,AX' + ENTER;

    FIN      := 'MOV AX,4C00H' + ENTER +
                'INT 21H' + ENTER +
                'END';
    Programa := '';
end;
end.
