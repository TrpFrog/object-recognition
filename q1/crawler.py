from icrawler.builtin import BingImageCrawler

crawl_image_keywords = [
    ['trumpet', 'トランペット'], 
    ['trombone', 'トロンボーン'], 
    ['frog', 'カエル'], 
    ['leek', 'ネギ']
]

for keywords in crawl_image_keywords:
    for keyword in keywords:
        dir_to_save_img = f"img/{keywords[0]}"
        crawler = BingImageCrawler(
            storage={"root_dir": dir_to_save_img},
            downloader_threads=5
        )
        crawler.crawl(
            keyword=keyword,
            max_num=100,
            file_idx_offset='auto'
        )
