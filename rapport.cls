%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   {Användning av klassen:
%   Görs som \documentclass{rapport}
%   Språk kan specificeras genom options, \documentclass[english/swedish]{rapport}
%   }
%
%   {Inställningar för försättsblad:
%   Obligatoriska:  \title - Sätter huvudtitel
%                   \author - Sätter författare, flera författare separeras med \\. * ändrar till plural.
%   
%   Frivilliga:     \email[title]{adresser} - Sätter författares epost, separera flera med \\
%                   \date - Sätter datum, standard är \today
%                   \toptext - Sätter överrubrik
%                   \subtext - Lägger till extra text under allt annat
%                   \conducted[Förtext, rad 1]{###}[Förtext, rad 2][Text, rad 2] - Ändrar försättsbladet så datumet delas i två fält, Lab conducted: ### \\ Report submitted: \date
%                   \institution - Ändrar universitetsname i övre vänstra hörnet
% 
%   }
%   
%   {Globala macros:
%   \header[vänster]<mitten>=höger= - Sätter en header updelad i tre delar på alla sidor
%   \countinsec - Räknar figures, tables och equation i sections, t.ex. figure 1 -> figure 1.1
%
%   \paran - Streamlinar \right( \left), \paran{#} = \right( # \left), kräver math mode
%   \brackets - Puts nice brackets around things, requires math mode
%   \atom{betäckning}{masstal}[atomnummer][neutrontal] - Properties of an atom
%   
%   Listings för Python: använd [language=PythonPlus]
%
%
%   }
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\ProvidesClass{rapport}[24.06.02]
\NeedsTeXFormat{LaTeX2e}

%Processing class options
\DeclareOption{swedish}{\def\lang{swedish}}
\DeclareOption{english}{\def\lang{english}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage{xparse} %Ger NewDocumentCommand
\RequirePackage[utf8]{inputenc}
\RequirePackage[a4paper,top=2cm,bottom=2cm,left=1in,right=1in,marginparwidth=1.75cm]{geometry}
\RequirePackage{amsmath,amsthm,amsfonts,amssymb,amscd}
\RequirePackage{graphicx}
\RequirePackage{multirow}
\RequirePackage[table, dvipsnames]{xcolor} % Fler färger
\RequirePackage[colorlinks=false, allcolors=blue]{hyperref}
\RequirePackage{parskip} %% Tillåter vanligt radbyte
\RequirePackage{esvect} %Vektortecken
\RequirePackage{siunitx, tabularx} %Eneheter i math environment, Allows for S as tabular alignment, begin{tabular}{lSSS}, for aligning the decimal points.
\sisetup{
inline-per-mode = symbol,
separate-uncertainty = true}
\RequirePackage{lipsum, blindtext}%http://ctan.org/pkg/lipsum
\RequirePackage[outline]{contour}% http://ctan.org/pkg/contour
\RequirePackage{float} %Allows using H in tables in figures
\RequirePackage[export]{adjustbox}
\RequirePackage{mathtools}
\RequirePackage{nicefrac} %Allows 1/2 style fracs
\RequirePackage{hyperref} %Enables \href
\RequirePackage{caption, subcaption} %Allows for subfigure
\RequirePackage{listings} %allows code listing \begin{lstlisting}[language=Python] ... \end{lstlisting}
\RequirePackage{diagbox}
\RequirePackage{expl3} %Wrapper for LaTeX3
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}
\RequirePackage[outputdir=.output/]{minted} % Code listing
\RequirePackage{csquotes}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}


% ===============
%%% Table formating
% ===============

\RequirePackage{booktabs}
    \setlength\heavyrulewidth{0.20ex}
    \setlength\cmidrulewidth{0.10ex}
    \setlength\lightrulewidth{0.10ex}

\RequirePackage[font=normalsize,labelfont={bf}]{caption} % Makes Figure x.x / Table x.x in captions bf
    \captionsetup[table]{aboveskip=3pt}
    \captionsetup[figure]{aboveskip=3pt}


% ===============
%%% Counts figures within sections
% ===============
\def\countinsec{
    \counterwithin{figure}{section}
    \counterwithin{equation}{section}
    \counterwithin{table}{section}
}

% ===============
%%% Defining universal macros %%%
% ===============

%\paran - Puts nice brackets around things
\NewDocumentCommand\paran{m}{\left(#1\right)}

%\brackets - Puts nice brackets around things
\NewDocumentCommand\brackets{m}{\left[#1\right]}

%\atom - Properties of an atom
\ProvideDocumentCommand\atom{mmO{}O{}}{\text{$^{#2}_{#3}{\text{#1}}_{#4}$}}

%\header
\NewDocumentCommand{\header}{od<>d==}{
\pagestyle{fancy}
\fancyhf{}
    \IfNoValueTF{#1}{
        \fancyhead[HC]{}
    }{
        \fancyhead[HL]{#1}
    }
    \IfNoValueTF{#2}{
        \fancyhead[HL]{\title}
    }{
        \fancyhead[HC]{#2}
    }
    \IfNoValueTF{#3}{
        \fancyhead[HR]{\leftmark}
    }{
        \fancyhead[HR]{#3}
    }
    \fancyfoot[C]{\thepage}

}


% ===============
%%% Handlig language options %%%
% ===============
%Catching the case when no option is used
\ifx\lang\undefined
\def\lang{english}
\fi

%Defining words used on the titlepage
\def\empty{}
\def\@svenska{swedish}
\def\@engelska{english}

%%% Svenska =====
\ifx\lang\@svenska
% Author
\RenewDocumentCommand\author{s m}{
    \def\@author{\textit{författare} \\  \textbf{#2}}
    \def\@auth{#2}
}
%Conducted
\NewDocumentCommand\conducted{s O{Laboration genomförd: } m O{Rapport inlämnad: }O{\date}}{
    \def\@conducted{#2#3 \\ #4#5}
}

%Email
\NewDocumentCommand\email{O{\textit{E-post}} m}{
    \def\@email{#1 \\ #2}
}
% University if \institution is not used
\def\@uni{Lunds Universitet}
\else
%%% English =====
\ifx\lang\@engelska
% Author
\RenewDocumentCommand\author{s m}{
    \IfBooleanTF{#1}
    {\def\@author{\textit{authors} \\  \textbf{#2}
    \def\@auth{#2}}
    }{\def\@author{\textit{author} \\  \textbf{#2}}
    \def\@auth{#2}}
}
%Conducted
\NewDocumentCommand\conducted{s O{Lab Conducted: } m}{
    \def\@conducted{#2 #3}
}

%Email
\NewDocumentCommand\email{O{\textit{E-mail}} m}{
    \def\@email{#1 \\ #2}
}
% University if \institution is not used
\def\@uni{Medical Radiation Physics, \\Lund University,\\Sweden}
\fi
\fi

%Importing the babel package
\RequirePackage[\lang]{babel}

% ===============
%%% Creating the titlepage %%%
% ===============

%Provide commands for the variable parts of the titlepage
\def\title#1{\def\title{#1}}
\def\date#1{\def\date{#1}}
\def\toptext#1{\def\toptext{#1}}
\def\subtext#1{\def\subtext{#1}}
\def\logo#1{\def\logo{#1}}
\def\institution#1{\def\institution{#1}}

%Inputting the title page at the start of the document
\AtBeginDocument{
% Handling secondary defenitions
\if\date\empty
    \renewcommand\date{\today}
\fi


\begin{titlepage}
 \begin{center}
        \noindent
        \begin{minipage}{.55\textwidth}
            %%% Insitution [top left corner]
            \ifdefined\institution
            \Large \institution
            \else
            \Large \@uni
            \fi 
            %%%
        \end{minipage}
        \begin{minipage}{.40\textwidth}
        \begin{flushright}
            %%% Date [top right corner]
            \ifdefined\@conducted
            \else
            \Large \date
            \fi
            
            \Large LuRaCs version: \input{version.tex}
            %%%
        \end{flushright}  
        \end{minipage}

        \vspace*{3cm} % Space for title
        \LARGE
        %%% Text above the title
        \ifdefined\toptext
        \toptext
        \fi
        %%%

        \rule{14cm}{0.2mm} % Top line in title
        \vspace*{.4cm}


        %%% Title
        \Huge
        \ifdefined\title
        \textbf{\title}
        \else
        \textcolor{red}{\title}
        \fi
        \Large
        %%%

        \rule{14cm}{0.5mm} % Bottom line in title

        %%% Subtext
        \ifdefined\subtext
        \subtext
        \fi
        %%%
       
        \vspace{.6cm}
        \noindent
        \begin{minipage}{.45\textwidth}
            %%% Author [left]
            \ifdefined\@author
            \@author
            \else
            \textcolor{red}{\\author}
            \fi
            %%%
        \end{minipage}
        \begin{minipage}{.45\textwidth}
        \begin{flushright}
            %%% Email
            \ifdefined\@email
            \@email
            \fi
            %%%
        \end{flushright}  
        \end{minipage}

        \vspace{1.5cm}
        %%% Conducted
        \ifdefined\@conducted
        \@conducted
        \fi
        %%%


        
        %%% Logo [bottom of page]
        \if\logo\empty\else
        \begin{figure}[H]
        \centering
        \includegraphics[width = .5\linewidth]{\logo}
        \end{figure}
        \fi
        \vfill

        %Department of Physics
   \end{center}

\begin{minipage}{.5\textwidth}
\begin{flushleft}
\includegraphics[width=.5\linewidth]{LU_logo.png}
\end{flushleft}
\end{minipage}
\begin{minipage}{.5\textwidth}
\begin{flushright}
\includegraphics[width=.4\linewidth]{cc-by-sa.png}
\end{flushright}
\end{minipage}


\end{titlepage}

}

% ===============
%%% Listings for python code

% Deprecated !!!

% ===============

% %%% Packages %%%
% \RequirePackage{listings}
% 
% \definecolor{backcolour}{rgb}{0.95,0.95,0.92}
% \renewcommand{\lstlistingname}{\textbf{Code Listing}} % Makes label bf
% %%% Defining new version of the python language %%%
% \lstdefinelanguage{PythonPlus}[]{Python}{
%     %
%     %%% general listing options %%%
%     xrightmargin=1cm,
%     xleftmargin=1cm,
%     aboveskip=1em,
%     breaklines=true,
%     abovecaptionskip=6pt,
%     captionpos=b,
%     escapeinside={(¤}{¤)},
%     frame=single,
%     numbers=left,
%     numbersep=6pt,
%     numberstyle=\scriptsize,
%     showstringspaces=false,
%     deletekeywords={,print,},
%     %
%     %%% Adding python keywords %%%
%     %
%     % Python builtin
%     morekeywords=[1]{,as,assert,nonlocal,with,yield,True,False,None,},
%     %
%     % Common functions
%     morekeywords=[2]{,object,type,isinstance,copy,deepcopy,zip,enumerate,reversed,list,set,len,dict,tuple,range,xrange,append,execfile,real,imag,reduce,str,repr,print, any,all,abs, min, max, },
%     %
%     % Magic methods
%     morekeywords=[3]{,__abs__,__add__,__and__,__bool__,__ceil__,__class__,__delattr__,
%     __dir__,__divmod__,__doc__,__eq__,__float__,__floor__,__floordiv__,
%     __format__,__ge__,__getattribute__,__getnewargs__,__gt__,__hash__,
%     __index__,__init__,__init_subclass__,__int__,__invert__,__le__,
%     __lshift__,__lt__,__mod__,__mul__,__ne__,__neg__,__new__,__or__,
%     __pos__,__pow__,__radd__,__rand__,__rdivmod__,__reduce__,__reduce_ex__,
%     __repr__,__rfloordiv__,__rlshift__,__rmod__,__rmul__,__ror__,__round__,
%     __rpow__,__rrshift__,__rshift__,__rsub__,__rtruediv__,__rxor__,__setattr__,
%     __sizeof__,__str__,__sub__,__subclasshook__,__truediv__,__trunc__,__xor__,bit_length,
%     conjugate,denominator,from_bytes,imag,numerator,real,to_bytes,},
%     %
%     % Errors
%     morekeywords=[4]{,Exception,NameError,IndexError,SyntaxError,TypeError,ValueError,OverflowError,ZeroDivisionError,},
%     %
%     % Numpy/module functions
%     morekeywords=[5]{,ode,fsolve,sqrt,exp,sin,cos,arctan,arctan2,arccos,pi,array,norm,solve,dot,arange,isscalar,max,sum,flatten,shape,reshape,find,plot,linspace,legend,quad,polyval,polyfit,hstack,concatenate,vstack,column_stack,empty,zeros,ones,rand,vander,grid,pcolor,eig,eigs,eigvals,svd,qr,tan,det,logspace,roll,mean,cumsum,cumprod,diff,vectorize,lstsq,cla,eye,squeeze,
%     % Add module functions
%     },
%     %
%     % self
%     morekeywords=[6]{,self,},
% }

% %%% Color theme %%%
% \lstdefinestyle{colorEX}{
% basicstyle=\ttfamily,
% backgroundcolor=\color{backcolour},
% commentstyle=\color{gray}\slshape, % Comments
% keywordstyle=[1]\color{violet}, % Builtin
% keywordstyle=[2]\color{Orange}, % Common functions
% keywordstyle=[3]\color{Cyan}, % Magic methods
% keywordstyle=[4]\color{OrangeRed}, % Errors
% keywordstyle=[5]\color{NavyBlue}, % Numpy
% keywordstyle=[6]\color{Maroon}, % Self
% stringstyle=\color{ForestGreen}, % Strings
% emphstyle=\color{blue}\bf\underbar,
% literate=% Digit color
%     *
%     {0}{{{\color{Emerald}0}}}1
%     {1}{{{\color{Emerald}1}}}1
%     {2}{{{\color{Emerald}2}}}1
%     {3}{{{\color{Emerald}3}}}1
%     {4}{{{\color{Emerald}4}}}1
%     {5}{{{\color{Emerald}5}}}1
%     {6}{{{\color{Emerald}6}}}1
%     {7}{{{\color{Emerald}7}}}1
%     {8}{{{\color{Emerald}8}}}1
%     {9}{{{\color{Emerald}9}}}1
%     %{@}{{{\color{Maroon}@}}}1 % Decorators
% }

% %%% Setting the created style %%%
% \lstset{style=colorEX}


% Ska macros som \atom{1}{H} användas i rubriker ska det skrivas \texorpdfstring{\atom{1}{H}}

% \begin{figure}
%      \centering
%      \begin{subfigure}[b]{0.3\textwidth}
%          \centering
%          \includegraphics[width=\textwidth]{graph1}
%          \caption{}
%          \label{}
%      \end{subfigure}
%      \hfill
%      \begin{subfigure}[b]{0.3\textwidth}
%          \centering
%          \includegraphics[width=\textwidth]{graph2}
%          \caption{}
%          \label{}
%      \end{subfigure}
% \end{figure}
