def get_pair(x: str):
    if x == 'trumpet':
        return 'trombone'
    elif x == 'trombone':
        return 'trumpet'
    elif x == 'frog':
        return 'leek'
    elif x == 'leek':
        return 'frog'

with open('result.html', 'w') as html:
    html.write('<html>\n')
    html.write('''
        <head>
            <style>
                .grid {
                    text-align: center;
                    padding: 1em;
                }

                .grid * + * {
                    margin-left: 10px;
                }

                .good {
                    background: #dbffb7;
                }

                .bad {
                    background: #ffdbb7;
                }

                .grid div {
                    display: inline-block;
                }

                .grid div * {
                    display: block;
                }

                h2 {
                    margin-top: 2em;
                }

                body {
                    width: 1000px;
                    margin: 2em auto;
                }
            </style>    
        </head>
    ''')
    html.write('<body>\n')

    html.write('<h1>実験課題1の結果</h1>')
    with open('result.txt', 'r') as f:
        content = f.readlines()
        cnt = 0
        cnt_increase = 0
        is_good = True

        for line in content:
            if cnt > 0:
                if cnt_increase == 0:
                    html.write('<h3>正しく分類された中で最もスコアの高かった3つの画像</h3>\n')
                    html.write('<div class="grid good">\n')
                    is_good = True
                    
                
                if cnt_increase == 3:
                    html.write('</div>\n')
                    html.write('<h3>誤って分類された中で最もスコアの高かった3つの画像</h3>\n')
                    html.write('<div class="grid bad">\n')
                    is_good = False


                tmp = line.strip().split(' ')
                src = tmp[0]
                val = tmp[1]
                correct = src.split('/')[1].strip()

                html.write(f'<div>')
                html.write(f'<img width="300" src="../q1/{src}">')
                html.write(f'<span>{src}<br>Result: {correct if is_good else get_pair(correct)}<br>Answer: {correct}<br>{val}</span>')
                html.write(f'</div>\n')

                if cnt_increase == 2 and cnt == 1:
                    html.write('</div>\n')
                    html.write('<h3>誤って分類された中で最もスコアの高かった3つの画像</h3>\n')
                    html.write('<p>なし (分類率 100%)</p>\n')

                cnt -=1
                cnt_increase += 1
                if cnt == 0:
                    html.write('</div></div>\n')

            elif cnt == 0:
                html.write('<h2>' + line.strip() + '</h2>\n')
                cnt -= 1
            else:
                cnt = sum(map(lambda x: int(x), line.strip().split(' ')))
                cnt_increase = 0
                html.write('<div>')

    html.write('</body></html>')
