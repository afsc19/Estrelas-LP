% lp24 - ist1114254 - projecto 
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliacÃßaÃÉo teraÃÅ mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. NaÃÉo alterar.
% AtencÃßaÃÉo: nao deves copiar nunca os puzzles para o teu ficheiro de coÃÅdigo
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o coÃÅdigo
%%%%%%%%%%%%


% --------------------- 5.1 ---------------------

/*
    visualiza(Lista) :-
        Lista eh uma lista e o predicado, quando aplicado,
        escreve, por linha, cada elemento de Lista.
*/

visualiza([]).
visualiza([Elem|Resto]) :-
    writeln(Elem),
    visualiza(Resto).


/*
    visualizaLinha(Lista) :-
        Lista eh uma lista e o predicado, quando aplicado,
        escreve, por linha, cada elemento de Lista, 
        antecedido do numero de cada linha.
*/

visualizaLinha(Lista) :-
    forall((
        nth1(Indice, Lista, Linha) % Calcula o indice da linha
        ), (
        write(Indice),
        write(": "),
        writeln(Linha)
        )).
    
/*
visualizaLinha(Lista) :- visualizaLinhaAux(Lista, 0).
*/
/*
    visualizaLinhaAux(Lista,Ac) :-
        Lista eh uma lista, Ac eh a contagem das linhas
        e o predicado, quando aplicado, escreve cada elemento de Lista,
        antecedido da contagem Ac,que incrementa ao percorrer a Lista.
*/

visualizaLinhaAux([], _).
visualizaLinhaAux([Elem|Resto], Ac) :-
    Ac1 is Ac+1,
    write(Ac1),
    write(": "),
    writeln(Elem),
    visualizaLinhaAux(Resto, Ac1).



% --------------------- 5.2 ---------------------

/*
    insereObjecto((L, C), Tabuleiro, Obj) :-
        Tabuleiro eh um tabuleiro com o objeto Obj
        na linha L e na coluna C.
*/


% Caso a linha L esteja fora dos limites do Tabuleiro, nao faz nada.
insereObjecto((L, _), Tabuleiro, _) :-
    length(Tabuleiro, Len),
    (L<1; L>Len), !.

% Caso a coluna C esteja fora dos limites do Tabuleiro, nao faz nada.
insereObjecto((L, C), Tabuleiro, _) :-
    nth1(L, Tabuleiro, Linha),
    length(Linha, Len),
    (C<1; C>Len), !.

% Caso ja exista uma estrela (e) ou um ponto (p), nao faz nada. 
insereObjecto((L, C), Tabuleiro, _) :-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, ObjEx),
    (ObjEx == e; ObjEx == p), !.

insereObjecto((L,C), Tabuleiro, Obj) :-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Obj).

/*
    insereVariosObjectos(ListaCoords, Tabuleiro, ListaObjs) :-
        ListaCoords eh uma lista de coordenadas,
        ListaObjs eh uma lista de objetos
        e Tabuleiro que contem os objetos da ListaObjs
        nas coordenadas da ListaCoords.
        Falha caso as dimensoes das listas sejam diferentes.
*/

% Caso em que as dimensoes sao diferentes.
insereVariosObjectos(L1, _, L2) :-
    length(L1, Len1),
    length(L2, Len2),
    Len1 \= Len2, !, fail.

insereVariosObjectos([], _, []) :- !.
insereVariosObjectos([Coord1|RCoords], Tabuleiro, [Obj1|RObjs]) :-
    insereObjecto(Coord1, Tabuleiro, Obj1),
    insereVariosObjectos(RCoords, Tabuleiro, RObjs).


/*
    inserePontosVolta(Tabuleiro, (L, C)) :-
        Tabuleiro eh um tabuleiro com pontos (p)
        em roda das coordenadas (L, C),
        onde L eh uma linha e C uma coluna do Tabuleiro.
*/

inserePontosVolta(Tabuleiro, (L, C)) :- 
    coordsAdjacentes((L, C), ListaAdjs),
    % Oito pontos (p), correspondentes ‡s oito coordenadas adjacentes.
    Objetos = [p,p,p, p,p, p,p,p],
    insereVariosObjectos(ListaAdjs, Tabuleiro, Objetos).


/*
    Predicado auxiliar:
    coordsAdjacentes(Coord, ListaAdjs) :-
        Coord eh uma coordenada e ListaAdjs eh a lista
        das 8 coordenadas adjacentes a Coord.
*/

coordsAdjacentes((L, C), ListaAdjs) :-
    % Calcula as linhas e colunas adjacentes. (anteriores e seguintes)
    La is L-1, Ls is L+1,
    Ca is C-1, Cs is C+1,
    % Prepara as coordenadas dos 8 pontos adjacentes.
    ListaAdjs = [(La, Ca), (La, C), (La, Cs),
            (L, Ca), (L, Cs),
            (Ls, Ca), (Ls, C), (Ls, Cs)].


/*
    inserePontos(Tabuleiro, ListaCoord) :-
        Tabuleiro eh um tabuleiro e
        ListaCoord eh uma lista com coordenadas
        do Tabuleiro que contÍm pontos.
*/

inserePontos(_, []) :- !.
inserePontos(Tabuleiro, [Coord1|RCoords]) :-
    insereObjecto(Coord1, Tabuleiro, p),
    inserePontos(Tabuleiro, RCoords).


% --------------------- 5.3 ---------------------


/*
    objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjs) :-
        Tabuleiro eh um tabuleiro e
        ListaObjs eh a lista com os objetos presentes em cada
        uma das coordenadas da lista ListaCoords no Tabuleiro.
*/

objectosEmCoordenadas([], _, []) :- !.
objectosEmCoordenadas([(L, C)|RCoords], Tabuleiro, [Obj|RObjs]) :-
    nth1(L, Tabuleiro, Linha),
    nth1(C, Linha, Obj),
    objectosEmCoordenadas(RCoords, Tabuleiro, RObjs).



/*
    coordObjectos(Objecto, Tabuleiro, ListaCoords, ListaCoordObjs, NumObjectos) :-
        Objecto eh um objecto, Tabuleiro eh um tabuleiro,
        ListaCoords eh uma lista que contem coordenadas do Tabuleiro,
        ListaCoordObjs eh a sublista ordenada de ListaCoords
        cujas coordenadas correspondem ao Objecto,
        NumObjectos eh o numero de Objectos presentes nas coordenadas das listas.
*/


coordObjectos(Obj, Tabuleiro, ListaCoords, ListaCoordObjsOrd, NumObjectos) :-
    objectosEmCoordenadas(ListaCoords, Tabuleiro, ListaObjectos),

    % Filtra a ListaCoords.
    findall(Coord, (
        nth1(ILista, ListaCoords, Coord),
        nth1(ILista, ListaObjectos, Elem),
        % Caso sejam ambos vari·veis.
        (var(Elem), var(Obj);
        % Caso sejam iguais.
        Obj == Elem)
    ), ListaCoordObjs),

    sort(ListaCoordObjs, ListaCoordObjsOrd),
    length(ListaCoordObjsOrd, NumObjectos).


/*
    coordenadasVars(Tabuleiro, ListaVars) :-
        Tabuleiro eh um Tabuleiro e 
        ListaVars eh a lista ordenada com todas as
        coordenadas do Tabuleiro que contenham variaveis.
*/

coordenadasVars(Tabuleiro, ListaVarsOrd) :-
    findall((L,C), (
        nth1(L, Tabuleiro, Linha),
        nth1(C, Linha, Elem),
        var(Elem)
        ), ListaVars),
    sort(ListaVars, ListaVarsOrd).



% --------------------- 5.4 ---------------------


/*
    fechaListaCoordenadas(Tabuleiro, ListaCoord) :-
        Tabuleiro eh um tabuleiro e ListaCoord eh uma lista
        de coordenadas do Tabuleiro que ser„o pontos e estrelas,
        de acordo com as hipoteses (h1-h2-h3) descritas no enunciado.
        O Tabuleiro mantem-se inalterado caso
        nenhuma das hipoteses se verifique.
*/

fechaListaCoordenadas(Tabuleiro, ListaCoord) :-
    % Caso existam duas estrelas.
    coordObjectos(e, Tabuleiro, ListaCoord, ListaCoordEstrelas, 2), !,

    % Filtra as coordenadas com estrelas.
    exclude(membro(ListaCoordEstrelas), ListaCoord, ListaCoordSemEstrelas),
    
    inserePontos(Tabuleiro, ListaCoordSemEstrelas).

% Caso exista uma estrela e uma variavel.
fechaListaCoordenadas(Tabuleiro, ListaCoord) :-
    % Filtra as coordenadas que nao correspondem a variaveis.
    coordenadasVars(Tabuleiro, ListaVars),
    include(membro(ListaVars), ListaCoord, ListaCoordVars),

    coordObjectos(e, Tabuleiro, ListaCoord, _, NEstrelas),
    length(ListaCoordVars, NVars),
    
    % Caso exista (1 estrela e 1 variavel) ou (2 estrelas e 2 variaveis).
    (NEstrelas==1, NVars==1 ;
    NEstrelas==0, NVars==2), !,

    maplist(insereEstrelaPontosVolta(Tabuleiro), ListaCoordVars).

fechaListaCoordenadas(_, _).

% Predicado auxiliar para inserir estrela e pontos ‡ volta
% das coordenadas Coords no tabuleiro Tabuleiro.
insereEstrelaPontosVolta(Tabuleiro, Coords) :-
    insereObjecto(Coords, Tabuleiro, e),
    inserePontosVolta(Tabuleiro, Coords).

% Predicado auxiliar com o intuito de ser utilizada no exclude. (ordem de argumentos)
membro(List, Elem) :- member(Elem, List).


/*
    fecha(Tabuleiro, ListaListasCoord) :-
        Tabuleiro eh um tabuleiro e ListaListasCoord eh uma Lista de listas
        ‡s quais ser„o aplicadas o predicado fechaListaCoordenadas.
*/

fecha(Tabuleiro, ListaListasCoord) :-
    maplist(fechaListaCoordenadas(Tabuleiro), ListaListasCoord).


/*
    encontraSequencia(Tabuleiro, N, ListaCoords, Seq) :-
        Tabuleiro eh um tabuleiro, N eh o tamanho de Seq,
        ListaCoords eh uma lista de coordenadas do Tabuleiro
        e Seq eh uma sublista de ListaCoords que verifica os seguintes critÈrios:
        - As suas coordenadas representam posiÁıes com vari·veis;
        - As suas coordenadas aparecem seguidas;
        - Seq pode ser concatenada com duas listas, uma antes e uma depois,
        eventualmente vazias ou com pontos nas coordenadas respectivas,
        permitindo obter ListaCoords.
        Se houver mais vari·veis na sequÍncia que N o predicado falha.
*/

encontraSequencia(Tabuleiro, N, ListaCoords, Seq) :-
    coordenadasVars(Tabuleiro, ListaVars),
    % Gera a Seq.
    findall(Coord,(
        member(Coord, ListaCoords),
        member(Coord, ListaVars)
        ), Seq),
    
    append([Antes, Seq, Depois], ListaCoords),
    (length(Antes, 0) ; % Ou n„o existem coordenadas antes, ou s„o todas pontos.
    coordObjectos(p, Tabuleiro, Antes, _, NumPs), length(Antes, NumPs)),
    (length(Depois, 0) ; % Ou n„o existem coordenadas depois, ou s„o todas pontos.
    coordObjectos(p, Tabuleiro, Depois, _, NumPs), length(Depois, NumPs)),
    
    !, length(Seq, N).


/*
    aplicaPadraoI(Tabuleiro, [(L1, C1), (L2, C2), (L3, C3)]) :-
        Tabuleiro eh um tabuleiro com duas estrelas em (L1, C1)
        e em (L3, C3) com os respetivos pontos a volta, sendo que
        [(L1, C1), (L2, C2), (L3, C3)] eh uma lista de coordenadas.
*/

aplicaPadraoI(Tabuleiro, [Coord1, _, Coord3]) :-
    insereEstrelaPontosVolta(Tabuleiro, Coord1),
    insereEstrelaPontosVolta(Tabuleiro, Coord3).


/*
    aplicaPadroes(Tabuleiro, ListaListaCoords) :-
        Tabuleiro eh um tabuleiro e
        ListaListaCoords eh uma lista de listas com coordenadas;
        apos a aplicacao deste predicado:
        - ter-se-ao encontrado sequencias de tamanho 3 e aplicado o aplicaPadraoI/2,
        - ou entao ter-se-ao encontrado sequencias de tamanho 4 e aplicado o aplicaPadraoT/2.
*/

aplicaPadroes(_, []) :- !.

aplicaPadroes(Tabuleiro, [ListaCoords|RListaCoords]) :-
    % Caso encontre sequencias de 3 ou 4 variaveis, aplica o padrao correspondente.
    ((encontraSequencia(Tabuleiro, 3, ListaCoords, Seq3),
    aplicaPadraoI(Tabuleiro, Seq3)) ;
    (encontraSequencia(Tabuleiro, 4, ListaCoords, Seq4),
    aplicaPadraoT(Tabuleiro, Seq4)) ;
    true), % Caso contr·rio, continua a percorrer a ListaListaCoords.

    aplicaPadroes(Tabuleiro, RListaCoords).



% --------------------- 5.5 ---------------------

/*
    resolve(Estrutura, Tabuleiro) :-
        Estrutura eh uma estrutura e Tabuleiro eh um tabuleiro
        que resulta de aplicar os predicados aplicaPadroes/2 e fecha/2
        ate ja nao haver mais alteracoes nas variaveis do Tabuleiro.
        Em alguns casos, este predicado resolve o desafio ate ao fim.
*/

resolve(Estrutura, Tabuleiro) :-
    coordenadasVars(Tabuleiro, ListaVarsAntes),

    coordTodas(Estrutura, CT), % Prepara as listas com coordenadas.
    aplicaPadroes(Tabuleiro, CT),
    fecha(Tabuleiro, CT),
    
    coordenadasVars(Tabuleiro, ListaVarsDepois),
    % Caso as variaveis nao se tenham alterado, true.
    (ListaVarsAntes == ListaVarsDepois ;
    resolve(Estrutura, Tabuleiro)), % Caso contrario, resolve de novo.
    !. % Para evitar resolver sem ter alterado nada.
    


    