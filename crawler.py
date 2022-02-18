from icrawler.builtin import BingImageCrawler

crawl_image_keywords = [
    ['trumpet', 'トランペット'], 
    ['trombone', 'トロンボーン'], 
    ['frog', 'カエル'], 
    ['leek', 'ネギ']
]

for keywords in crawl_image_keywords:
    for keyword in keywords:
        crawler = BingImageCrawler(storage={"root_dir": f"img/{keywords[0]}"},downloader_threads=5)
        crawler.crawl(keyword=keyword, max_num=100, file_idx_offset='auto')
