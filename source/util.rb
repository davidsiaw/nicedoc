class Util
    include Singleton

    def fonts
      {
        unit: 'rem',
        faces: {
          p: 'Overpass',
          h1: 'LinLibertine',
          h2: 'LinLibertine',
          h3: 'LinLibertine',
          h4: 'LinLibertineCaps',
          h5: 'LinLibertineCaps',
          h6: 'LinLibertineCaps',
        },
        sizes: {
          p: 1.55,
          h1: 5,
          h2: 3.5,
          h3: 3,
          h4: 2.5,
          h5: 2.3,
          h6: 2.3,
        },
        weights: {
          p: 'normal',
          h1: 'bold',
          h2: 'bold',
          h3: 'bold',
          h4: 'bold',
          h5: 'normal',
          h6: 'bold',
        }
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
          indigo: 'hsla(232,75%,95%,1)'
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
        }
      }
    end
  
    def generate_css(profile=:indigo)
      File.write("css/#{profile}.css", out(profile))
    end
  
    def bigfonts
      (1..6).map do |x|
        sym = "h#{x}".to_sym
        <<~CSS
          #{sym} {
            font-family: '#{fonts[:faces][sym]}';
            font-size: #{fonts[:sizes][sym]}#{fonts[:unit]};
            font-weight: #{fonts[:weights][sym]};
            margin-top: 20px;
            margin-bottom: 10px;
          }
        CSS
      end.join("\n")
    end

    def out(profile)
      <<~CSS
  
      @media print {
        body {
        }
              
          .pagebreak {
            clear: both;
            page-break-after: always;
        }
      }
  
      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-extralight.ttf') format('truetype');
        font-weight: 100 200;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-regular.ttf') format('truetype');
        font-weight: 300 400;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-bold.ttf') format('truetype');
        font-weight: 500 600;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-heavy.ttf') format('truetype');
        font-weight: 700 800;
      }

      @font-face {
        font-family: 'Overpass';
        src:  url('overpass-heavy.ttf') format('truetype');
        font-weight: 900 900;
      }

      @font-face {
        font-family: 'InterLight';
        src:  url('Inter-Light-BETA.ttf') format('truetype')
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
        font-family: #{fonts[:faces][:p]};
        background-color: #{profiles[:bgcolor][profile]};
        color: #{profiles[:fgcolor][profile]};
        text-align: justify;
        text-justify: inter-word;


        font-size: #{fonts[:sizes][:p]}#{fonts[:unit]};
        font-weight: 100;
      }
  
      body:not(.mini-navbar) {
        background-color: #{profiles[:bgcolor][profile]};
  
      }
  
      @font-face {
        font-family: 'FiraCodeLight';
        src:  url('FiraCode-Light.ttf') format('truetype')
      }
  
  
      @font-face {
        font-family: 'FiraCode';
        src:  url('FiraCode-Regular.ttf') format('truetype')
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
        font-size: #{fonts[:sizes][:p]}#{fonts[:unit]};
        font-family: Verdana;
        line-height: 1.0em;
        padding-top: 0em;
        padding-bottom: 0em;
      }
  
      .nav>li>a {
        font-size: #{fonts[:sizes][:p]}#{fonts[:unit]};
        color: #{profiles[:fgcolor][profile]};
        font-weight: 100;
        padding-left: 0.3rem;
        padding-top: 0.5rem;
        padding-bottom: 0.5rem;
      }
  
      #{bigfonts}
  
      hr {
        border-top: 2px solid #000;
      }
  
      li {
        font-weight: 100;
      }
  
      p {
        text-indent: 1.5em;
        margin-bottom: 20px;
      }
  
      p.noindent {
        text-align: justify;
        text-justify: inter-word;
        text-indent: 0em;
      }
  
      .dropcap {
        font-size: 5.5rem;
        float: left;
        margin-right: 0.2rem;
        margin-top: -1.5rem;
        margin-bottom: -3.0rem;
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
        font-size: 1.25rem;
        font-weight: 600;
        font-family: FiraCode;
      }

      .span-italics {
        font-style: italic;
      }
  
      .span-bold {
        font-weight: 300;
      }

      .span-verybold {
        font-weight: 600;
      }

      .span-superbold {
        font-weight: 900;
/*        color: #ff1e1e;*/
      }

      .span-underline {
        text-decoration: underline;
      }

      .span-strikethrough {
        text-decoration: line-through;
      }

      .span-overline {
        border-top: 1px solid hsla(232,15%,95%,1);
      }

      .span-code {
        font-size: 1.25rem;
        font-weight: bold;
        font-family: FiraCode;
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
      
      CSS
    end
  end
