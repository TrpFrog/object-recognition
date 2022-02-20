from icrawler.builtin import BingImageCrawler

dir_to_save_img = f"img/traffic_lights"
crawler = BingImageCrawler(
    storage={"root_dir": dir_to_save_img},
    downloader_threads=5
)
crawler.crawl(
    keyword='traffic lights',
    max_num=50
)
