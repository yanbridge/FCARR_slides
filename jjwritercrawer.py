import re
import pymysql
from urllib.request import urlopen
from lxml import etree

dbconfig = {"host": "fksad.top",
            "port": 3306,
            "user": "guest",
            "password": "Guest@fksad1992",
            "db": "GuestDB",
            "charset": "utf8mb4"}
conn = pymysql.connect(**dbconfig)
cur = conn.cursor()
cur.execute("SELECT DISTINCT writer_url FROM jjwxc_novel_label LIMIT 10;")
res = cur.fetchall()


def JJCrawler(url, cur, varlst):
    '''
    Function for crawl writer information from jin jiang wen xue cheng
    url: string; the url of writer
    conn: a connection to the mysql db for storage
    '''
    response = urlopen(url)
    content = response.read().decode('gb2312')
    html = etree.HTML(content)

    writer_code = html.xpath("//table[1]//td[@class='lefttd'][1]//tr[1]/td/font/b/text()")[0]
    writer_code = int(writer_code)
    writer_name = html.xpath("//span[@class='volumnfont']/font/b/text()")[0].strip()
    writer_recommend_count = html.xpath("//td[@class='lefttd'][1]//tr[2]//tr[1]/td[1]/text()")[1].strip()
    writer_recommend_count = int(re.findall(r"\d+", writer_recommend_count)[0])
    novel_name = html.xpath("//table[4]//td[1]//tr/td/a/text()")
    novel_name = [re.sub(r"\s+|\xa0", "", i.strip()) for i in novel_name]
    novel_type = html.xpath("//table[4]//td[2]/text()")[1:]
    novel_type = [re.sub(r"\s+|\xa0", "", i.strip()) for i in novel_type]
    novel_style = html.xpath("//table[4]//td[3]/text()")[1:]
    novel_status = html.xpath("//table[4]//td[4]/text()")[1:]
    novel_word_count = html.xpath("//table[4]//td[5]/text()")[1:]
    novel_word_count = [int(re.sub(r"\s+|\xa0", "", i.strip())) for i in novel_word_count]
    novel_score = html.xpath("//table[4]//td[6]/text()")[1:]
    novel_score = [int(re.sub(",", "", re.sub(r"\s+|\xa0", "", i.strip()))) for i in novel_score]
    novel_release_date = html.xpath("//table[4]//td[7]/text()")[1:]
    # d
    vallst = [writer_code, writer_name, writer_recommend_count, novel_name, novel_type, novel_style,
              novel_status, novel_word_count, novel_score, novel_release_date]
    # d
    query = "INSERT INTO jjwxc_wrier_info({}) VALUES({})".format(",".join(varlst), ",".join(vallst))
    cur.execute(query)

varlst = ["writer_code", "writer_name", "writer_recommend_count", "novel_name", "novel_type", "novel_style",
          "novel_status", "novel_word_count", "novel_score", "novel_release_date"]

tmp_url = res[8][0]
JJCrawler(tmp_url, cur, varlst)
conn.close()
