class Util
    include Singleton

    def fonts(pagetype)

      basictext = 'EBGaramond'
      basictext = 'SourceSerif' if pagetype == :blog || pagetype == :opinion

      basicsize = 1.9
      basicsize = 1.7 if pagetype == :blog || pagetype == :opinion

      headertext = 'LinLibertine'
      headertext = 'Overpass' if pagetype == :blog || pagetype == :opinion
      #headertext = 'FiraCode' if pagetype == :blog


      basictext = 'SourceSerif' if pagetype == :menu

      basicsize = 1.4 if pagetype == :menu

      headertext = 'Overpass' if pagetype == :menu

      indent_amt = 1.5
      indent_amt = 0 if pagetype == :opinion || pagetype == :article



      {
        unit: 'rem',
        faces: {
          body: basictext,
          p:    basictext,
          pre: 'FiraCode',
          h1: headertext,
          h2: headertext,
          h3: headertext,
          h4: headertext,
          h5: headertext,
          h6: headertext,
        },
        sizes: {
          body: basicsize,
          p: basicsize,
          pre: 1.55,
          h1: 4,
          h2: 3,
          h3: 2.5,
          h4: 2.5,
          h5: 2.3,
          h6: 2.3,
          indent: indent_amt
        },
        weights: {
          body: 100,
          p: 'lighter',
          pre: 'normal',
          h1: 'bold',
          h2: 'bold',
          h3: 'bold',
          h4: 'bold',
          h5: 'normal',
          h6: 'bold',
        },
        margin_top: {
          body: 0,
          p: 0,
          pre: 0,
          h1: 20,
          h2: 20,
          h3: 20,
          h4: 20,
          h5: 20,
          h6: 20,

        },
        margin_bottom: {
          body: 0,
          p: 0,
          pre: 0,
          h1: 10,
          h2: 10,
          h3: 10,
          h4: 10,
          h5: 10,
          h6: 10,
        },
        text_align: {
          body: 'justify',
          p:   'justify',
          pre: 'left',
          h1: 'left',
          h2: 'left',
          h3: 'left',
          h4: 'left',
          h5: 'left',
          h6: 'left',
        },
      }
    end
  
    def profiles
      {
        bgcolor: {
          print: '#fff',
          indigo: 'hsla(232,15%,21%,1)'
        },
        fgcolor: {
          print: '#000',
          indigo: 'hsla(232,75%,95%,80%)'
        },
        prebgcolor: {
          print: '#eee',
          indigo: 'hsla(232,15%,15%,1)'
        },
        prefgcolor: {
          print: '#000',
          indigo: 'hsla(232,18%,86%,1)'
        },
        linkcolor: {
          print: '#337ab7',
          indigo: '#4d8bc1'
        },
        headcolor: {
          print: '#000',
          indigo: 'hsla(232,75%,95%,1)'
        }
      }
    end
  
    def generate_css(profile=:indigo)
      File.write("css/#{profile}.css", out(profile))
      File.write("css/#{profile}-article.css", out(profile, :article))
      File.write("css/#{profile}-blog.css", out(profile, :blog))
      File.write("css/#{profile}-opinion.css", out(profile, :opinion))
      File.write("css/#{profile}-manual.css", out(profile, :manual))
    end
  
    def bigfonts(pagetype)
      fonttags = (1..6).map { |x| "h#{x}".to_sym } + %i[
                  p
                  body
                  pre
                ]

      fonttags.map do |sym|
        <<~CSS
          #{sym} {
            font-family: '#{fonts(pagetype)[:faces][sym]}';
            font-size: #{fonts(pagetype)[:sizes][sym]}#{fonts(pagetype)[:unit]};
            font-weight: #{fonts(pagetype)[:weights][sym]};
            margin-top: #{fonts(pagetype)[:margin_top][sym]}px;
            margin-bottom: #{fonts(pagetype)[:margin_bottom][sym]}px;
          }

          .menu #{sym} {
            font-family: '#{fonts(:blog)[:faces][sym]}';
            font-size: #{fonts(:blog)[:sizes][sym]}#{fonts(pagetype)[:unit]};
            font-weight: #{fonts(:blog)[:weights][sym]};
            margin-top: #{fonts(:blog)[:margin_top][sym]}px;
            margin-bottom: #{fonts(:blog)[:margin_bottom][sym]}px;
          }
        CSS
      end.join("\n")
    end

    def syntax_theme(profile)
      File.read("css/syntax-#{profile}.css")
    end

    def out(profile, pagetype=:article)
      <<~CSS
  

      @media print {
        body {
        }
              
        .pagebreak {
          clear: both;
          page-break-after: always;
        }

        .span-overline {
          border-top: 1px solid;
        }
      
        #{syntax_theme(:print)}

        .col-print-12 {width: 100%; margin-left:0px;}
        .col-print-hidden { display: none}
      } /* @media print */

      @media screen {
        #{syntax_theme(profile)}
      }
  
      @font-face {
        font-family: 'FiraCode';
        src:  url('FiraCode-Light.ttf') format('truetype');
        font-weight: 200;
      }
  
      @font-face {
        font-family: 'FiraCode';
        src:  url('FiraCode-Regular.ttf') format('truetype');
        font-weight: 400;
      }
  
      @font-face {
        font-family: 'FiraCode';
        src:  url('FiraCode-SemiBold.ttf') format('truetype');
        font-weight: 600;
      }

      @font-face {
        font-family: 'FiraCode';
        src:  url('FiraCode-Bold.ttf') format('truetype');
        font-weight: 800;
      }
  
      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-Regular.ttf') format('truetype');
        font-style: normal;
        font-weight: 100 200;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-Bold.ttf') format('truetype');
        font-style: bolder;
        font-weight: 300 400;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-ExtraBold.ttf') format('truetype');
        font-style: bold;
        font-weight: 700 900;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-Italic.ttf') format('truetype');
        font-style: italic;
        font-weight: 100 200;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-BoldItalic.ttf') format('truetype');
        font-style: italic;
        font-weight: 300;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-extralight.ttf') format('truetype');
        font-weight: 200;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-regular.ttf') format('truetype');
        font-weight: 400;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-bold.ttf') format('truetype');
        font-weight: 600;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-heavy.ttf') format('truetype');
        font-weight: 800;
      }


      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-Light.ttf') format('truetype');
        font-weight: 200;
      }

      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-Medium.ttf') format('truetype');
        font-weight: 400;
      }

      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-Bold.ttf') format('truetype');
        font-weight: 600;
      }

      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-Black.ttf') format('truetype');
        font-weight: 800;
      }


      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-LightItalic.ttf') format('truetype');
        font-weight: 200;
        font-style: italic;
      }

      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-MediumItalic.ttf') format('truetype');
        font-weight: 400;
        font-style: italic;
      }

      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-BoldItalic.ttf') format('truetype');
        font-weight: 600;
        font-style: italic;
      }

      @font-face {
        font-family: 'SourceSerif';
        src:  url('SourceSerif4-BlackItalic.ttf') format('truetype');
        font-weight: 800;
        font-style: italic;
      }


      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-Regular.ttf') format('truetype');
        font-weight: 200;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-SemiBold.ttf') format('truetype');
        font-weight: 400;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-Bold.ttf') format('truetype');
        font-weight: 600;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-ExtraBold.ttf') format('truetype');
        font-weight: 800;
      }
      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-Italic.ttf') format('truetype');
        font-weight: 200;
        font-style: italic;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-SemiBoldItalic.ttf') format('truetype');
        font-weight: 400;
        font-style: italic;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-BoldItalic.ttf') format('truetype');
        font-weight: 600;
        font-style: italic;
      }

      @font-face {
        font-family: 'EBGaramond';
        src:  url('EBGaramond-ExtraBoldItalic.ttf') format('truetype');
        font-weight: 800;
        font-style: italic;
      }

      @font-face {
        font-family: 'InterLight';
        src:  url('Inter-Light-BETA.ttf') format('truetype');
      }

      @font-face {
        font-family: 'Inter';
        src:  url('Inter-Regular.ttf') format('truetype')
      }
  
      @font-face {
        font-family: 'Inter';
        src:  url('Inter-Bold.ttf') format('truetype');
        font-weight: bold;
      }
  
      @font-face {
        font-family: 'LinLibertine';
        src:  url('LinLibertine_aDRS.ttf') format('truetype')
        font-weight: 300 500;
      }
  
      @font-face {
        font-family: 'LinLibertine';
        src:  url('LinLibertine_RBI.ttf') format('truetype');
        font-style: italic;
      }
  
      @font-face {
        font-family: 'LinLibertine';
        src:  url('LinLibertine_RB.ttf') format('truetype');
        font-weight: 600 800;
      }
  
      @font-face {
        font-family: 'LinLibertineCaps';
        src:  url('LinLibertine_aS.ttf') format('truetype');
      }
  
      @font-face {
        font-family: 'LinLibertineCaps';
        src:  url('LinLibertine_aBS.ttf') format('truetype');
        font-weight: bold;
      }
  
      body {
        font-family: #{fonts(pagetype)[:faces][:p]};
        font-style: normal;

        background-color: #{profiles[:bgcolor][profile]};
        color: #{profiles[:fgcolor][profile]};
        text-align: #{fonts(pagetype)[:text_align][:p]};


        font-size: #{fonts(pagetype)[:sizes][:p]}#{fonts(pagetype)[:unit]};
        font-weight: 100;
      }
  
      body:not(.mini-navbar) {
        background-color: #{profiles[:bgcolor][profile]};
      }
  
      .gray-bg {
        background-color: #{profiles[:bgcolor][profile]};
      }
  
      .border-bottom {
        border-bottom: 0px !important;
      }
  
      .navbar-static-top {
        background: #{profiles[:bgcolor][profile]};
        display: none;
      }
  
      .nav>li {
        font-size: #{fonts(pagetype)[:sizes][:p]}#{fonts(pagetype)[:unit]};
        font-family: Verdana;
        line-height: 1.0em;
        padding-top: 0em;
        padding-bottom: 0em;
      }
  
      .nav>li>a {
        font-size: #{fonts(pagetype)[:sizes][:p]}#{fonts(pagetype)[:unit]};
        color: #{profiles[:fgcolor][profile]};
        font-weight: 100;
        padding-left: 0.3rem;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
      }
  
      #{bigfonts(pagetype)}
  
      hr {
        border-top: 2px solid #000;
      }
  
      p {
        text-indent: #{fonts(pagetype)[:sizes][:indent]}#{fonts(pagetype)[:unit]};;
        margin-bottom: 20px;
      }
  
      p.noindent {
        text-indent: 0em;
      }
  
      .dropcap {
        font-size: 6rem;
        float: left;
        margin-right: 0.2rem;
        margin-top: -1.7rem;
        margin-bottom: -3.0rem;
        font-weight: 500;
      }

      a {
        color: #{profiles[:linkcolor][profile]}
      }
  
      hr {
        border: 1px solid #{profiles[:prefgcolor][profile]};
      }
  
      blockquote {
        border: 0px;
        border-left: 5px solid #{profiles[:prefgcolor][profile]};
        padding: 5px 10px;
        font-size: 1.4rem;
      }
  
      .CodeMirror {
        /* Set height, width, borders, and global font properties here */
        font-family: FiraCode;
        height: 300px;
        border: 1px solid #{profiles[:prebgcolor][profile]};;
  
      }
  
      .CodeMirror-gutters {
        border-right: 1px solid #{profiles[:bgcolor][profile]};;
  
      }
  
      .CodeMirror-gutter {
        border: 1px solid #{profiles[:prebgcolor][profile]};;
        background-color: #{profiles[:prebgcolor][profile]};
        white-space: nowrap;
      }
  
      .CodeMirror-lines {
        white-space: nowrap;
        font-size: 1.25rem;
        font-family: FiraCode;
      }
  
      .CodeMirror.cm-s-default {
        background-color: #{profiles[:prebgcolor][profile]};
      }
  
      pre {
        border: 1px solid #{profiles[:prebgcolor][profile]};
        background-color: #{profiles[:prebgcolor][profile]};
        color: #{profiles[:prefgcolor][profile]};
      }

      pre.wrapped {
        text-wrap: balance;

      }

      .span-italics {
        font-style: italic;
      }
  
      .span-bold {
        font-weight: bolder;
      }

      .span-verybold {
        font-weight: bold;
      }

      .span-superbold {
        font-weight: superbold;
      }

      .span-underline {
        text-decoration: underline;
      }

      .span-strikethrough {
        text-decoration: line-through;
      }

      .span-overline {
        text-decoration: overline;

        /*border-top: 1px solid;*/
      }

      .span-code {
        font-size: #{fonts(pagetype)[:sizes][:pre]}#{fonts(pagetype)[:unit]};
        font-weight: #{fonts(pagetype)[:weights][:pre]};
        font-family: #{fonts(pagetype)[:faces][:pre]};
        border: 3px solid hsla(232,15%,15%,1);
        border-radius: 5px;
        background-color: hsla(232,15%,15%,1);
      }

      .btn-primary {
        background-color: #000;
        border-color: #000;
      }

      .simpletable .table {
        width: auto;
      }

      .simpletable .table>thead:first-child>tr:first-child>th {
        border-top: 1px solid #e7eaec;
      }
      .simpletable .table th {
        border: 1px solid #e7eaec;
      }
      .simpletable .table td {
        border: 1px solid #e7eaec;
      }
      .simpletable .pagination {
        display: none;
      }


      .ibox-title {
        background-color: hsla(232,15%,31%,1);
        border-color: hsla(232,15%,31%,1);
      }

      .ibox-content {
        background-color: hsla(232,15%,25%,1);
        border-color: hsla(232,15%,25%,1);
      }


      .n_bold {
        font-weight: bold;
      }

      .n_italic {
        font-style: italic;
      }

      .n_underline {
        text-decoration: underline;
      }

      .n_overline {
        text-decoration: overline;
      }

      .n_strikeout {
        text-decoration: line-through;
      }

  
  
      .blog h1 {
        font-family: FiraCode;
      }
  
      .blog h2 {
        font-family: FiraCodeLight;
      }
  
      .blog p {
        text-align: left;
        color: #{profiles[:prefgcolor][profile]};
        font-size: 1.25rem;
        font-weight: 600;
        font-family: FiraCodeLight;
        text-indent: 0em;
        white-space: pre-wrap;
      }

      .menu {
        margin-top: 2em;

        font-size: #{fonts(:menu)[:sizes][:p]}#{fonts(:menu)[:unit]};
        font-weight: 100;

      }

      .menu #selected {
        color: #{profiles[:fgcolor][profile]};
        margin-left: -10px;
        /* background-color: hsla(232,15%,50%,1); */
        /* border-left: 5px solid hsla(232,15%,50%,1); */
      }

      .menu #selected:after {
        font-family: "FontAwesome"; 
        font-weight: 900; 
        / * content: "\\f053";  */
        color: #{profiles[:fgcolor][profile]};
        position: absolute;
        left: 10px ;
      }
      .menu #selected:before {
        font-family: "FontAwesome"; 
        font-weight: 900; 
        content: "\\f054"; 
        color: #{profiles[:fgcolor][profile]};
        position: relative;
        right: 10px ;
      }

      .menu .panel-heading {
        background-color: transparent;
        padding: 0px;
        color: inherit;
      }

      .menu a.menulink {
        color: #{profiles[:linkcolor][profile]};
      }

      .menu a.menulink:hover, a.menulink:focus {
        color: #23527c;
      }


      .menu h5 {
        margin: 0px;
        font-family: '#{fonts(:menu)[:faces][:p]}';
        font-size: #{fonts(:menu)[:sizes][:p]}#{fonts(:menu)[:unit]};

        line-height: 1.42857143;
      }

      .menu .panel {
        background-color: transparent;
        border: 0px;
      }

      .menu .panel-body {
        padding: 0em;
        padding-left: 0.5em;
      }

      .menu  .panel-heading+.panel-collapse>.panel-body {

        border-top: 1px solid hsla(232,15%,50%,1);
      }

      .menu .panel-group {
        margin-bottom: 0px;
        margin-top: 0em;
      }

      .menu ul {
        text-align: left;
        padding-inline-start: 0px;
        list-style-type: none;
        margin-bottom: 0.5em;
            font-family: '#{fonts(:menu)[:faces][:p]}';
      }

      .menu .panel-title {
          color: #888;
      }

      .menu .panel-title a[data-toggle].collapsed:before {
          font-family: "FontAwesome"; 
          font-weight: 900; 
          content: "\\f105";
          color:  #{profiles[:fgcolor][profile]};
          position: absolute;
          right: 30px;
      }

      .menu .panel-title a[data-toggle]:not(.collapsed):after {
          font-family: "FontAwesome"; 
          font-weight: 900; 
          content: "\\f107"; 
          color:  #{profiles[:fgcolor][profile]};
          position: absolute;
          right: 30px;
      }


      CSS
    end
  end
