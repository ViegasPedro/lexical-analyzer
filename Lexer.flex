import java.util.ArrayList;
import java.util.List;
import src.Identifier;
%%
%{
	public int line = 1;
	public int lastId = 0;
	public int lastScope = 0;
	public List<Identifier> identifiers = new ArrayList<>();
	public boolean lastTokenIsType = false;
	public boolean lastReservedWordIsFor = false;
	public boolean isFirstLine = true;
%}


%class analyzer
%standalone
%line
%column

NEWLINE=\r\n|\r|\n
WORD=[A-Za-z_][A-Za-z_0-9]*
SPACE=[\n\r\ \t\b\012]
VARIABLE={WORD}
STRING=\"([^\\\"]|\\.)*\"
TYPES=void|float|int|char|string|double|short|signed|unsigned|long
RESERVED_WORD=#define|#include|clrscr|do|while|for|break|continue|switch|case|default|goto|printf|getch|scanf|if|else|return|NULL|null|asm|auto|const|static|sizeof|typedef|struct
RELATIONAL_OP="!="|"<"|"<="|"=="|">="|">"
LOGICAL_OP="||"|&&
ARITH_OP="++"|"+"|"-"|"*"|"/"
IMPORT_HEADER = <{WORD}.h>
DIGIT_INT=[0-9]+
DIGIT_FLOAT={DIGIT_INT}\.{DIGIT_INT}
DIGIT={DIGIT_INT}|{DIGIT_FLOAT}
EQUAL==
COMMA=,
SEMICOLON=;
AMP="&"
L_BRACKET="{"
R_BRACKET="}"
L_PAREN="("
R_PAREN=")"
L_SQ_BRACKET="["
R_SQ_BRACKET="]"

InputCharacter = [^\r\n]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}*
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

%%
{SPACE}					{/*ignore*/}
{NEWLINE}       		{ System.out.printf("\nLinha: %d - ", line++); }
{Comment} 				{ line+= yytext().split("\\r\\n|\\n|\\r", -1).length - 1; }
{IMPORT_HEADER}			{ System.out.printf("[import_header, %s]", yytext()); }
{RELATIONAL_OP}			{ System.out.printf("[relational_op, %s]", yytext()); }
{LOGICAL_OP}			{ System.out.printf("[logic_op, %s]", yytext()); }
{ARITH_OP}      		{ System.out.printf("[arith_op, %s]", yytext()); }
{DIGIT}         		{ System.out.printf("[num, %s] ", yytext()); }
{L_SQ_BRACKET}			{ System.out.printf("[l_sq_bracket, %s] ", yytext()); }
{R_SQ_BRACKET}			{ System.out.printf("[r_sq_bracket, %s] ", yytext()); }
{COMMA}					{ System.out.printf("[comma, %s] ", yytext()); }
{SEMICOLON}				{ System.out.printf("[semicolon, %s] ", yytext()); }
{EQUAL}					{ System.out.printf("[Equal_Op, %s] ", yytext()); }
{STRING}        		{ System.out.printf("[string_literal, %s] ", yytext()); }
{L_PAREN}        		{ System.out.printf("[l_paren, %s] ", yytext()); }
{R_PAREN}        		{ System.out.printf("[r_paren, %s] ", yytext()); }
{AMP}        			{ System.out.printf("[amp, %s] ", yytext()); }
{RESERVED_WORD}			{
							String reservedWord = yytext();
							
							if(isFirstLine){
								System.out.printf("\nLinha: %d - ", line++);
								System.out.printf("[reserved_word %s]", reservedWord);
								isFirstLine = false;
							}else {
								System.out.printf("[reserved_word %s]", reservedWord);
								//o escopo do for começa quando ele é identificado
								if(reservedWord.equalsIgnoreCase("for")){
									lastReservedWordIsFor = true;
									lastScope++;
								}
							}
						}
{TYPES}					{ 
							System.out.printf("[reserved_word, %s]", yytext());
							lastTokenIsType = true;
						}
{VARIABLE}				{
							String idName = yytext();
							//declaração de um novo identificador
							if(lastTokenIsType){
								identifiers.add(new Identifier(idName, lastScope, lastId));
								lastTokenIsType = false;
								System.out.printf("[id, %s] ", lastId++);
							} else {
								boolean foundIdInList = false;
								//itera de tras pra frente para procurar no maior escopo primeiro
								for (int i = identifiers.size() - 1; i >= 0; i--) {
									if(identifiers.get(i).getName().equalsIgnoreCase(idName)){
										System.out.printf("[id, %s] ", identifiers.get(i).getIdNumber());
										foundIdInList = true;
										break;
									}
								}
								//declaração de duas variaveis na mesma linha
								if(!foundIdInList){
									identifiers.add(new Identifier(idName, lastScope, lastId));
									System.out.printf("[id, %s] ", lastId++);
								}
									
							}
							
						}
{R_BRACKET}				{ 
							System.out.printf("[r_bracket, %s] ", yytext());
							identifiers.removeIf(id->id.getScope() == lastScope);
							lastScope--;
						}
{L_BRACKET}				{ 
							System.out.printf("[l_bracket, %s] ", yytext());
							//o escopo do for é aumentado quando ele é identificado
							if(lastReservedWordIsFor){
								lastReservedWordIsFor = false;
							} else {
								lastScope++;
							}
						}