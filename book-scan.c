/*
 * Book-Scan
 * ~~~~~~~~~
 * Scan Google Books with an isbn number and return the title of the book.
 * by Jon Bradley (weatchu@@gmail.com)
 */

#include <stdio.h>
#include <curl/curl.h>
#include <string.h>

size_t write_book_info(void *ptr, size_t size, size_t nmemb, void *stream); 

int main(int argc, char *argv[1])
{
  CURL *curl;
  CURLcode res;
  FILE *fp;
  char buf[1000];
  char buf2[1000];
 
  if(argc < 2) {
    printf("Usage: %s <isbn>\n", argv[0]);
    return(1);
  }

  printf("Start entering your isbn numbers:\n");
 
  while(1) { 
    fgets(buf2, 30, stdin);
    sprintf(buf,"https://www.googleapis.com/books/v1/volumes?q=isbn:%s", buf2);

    fp = fopen("search.txt","wt");
    curl = curl_easy_init();
    if(curl) {
      curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION,write_book_info);
      curl_easy_setopt(curl, CURLOPT_WRITEDATA,fp);
      curl_easy_setopt(curl, CURLOPT_URL, buf);
      res = curl_easy_perform(curl);

      /* always cleanup */
      curl_easy_cleanup(curl);
    }
    //printf("\n=eof=\n");
    fclose(fp);
    title_search();

  }
  return 0;
}

/*
 * get_book_info
 * ~~~~~~~~~~~~~
 * The callback function used by libcurl to read the data produced by
 * the google books search url.
 */
size_t write_book_info(void *ptr, size_t size, size_t nmemb, void *stream) {
  size_t retcode;
  retcode = fwrite(ptr, size, nmemb, stream);
  //fprintf(stderr, "*** We read %d bytes from file\n", retcode);
  return retcode;
}

int title_search(void) {
  FILE *fp,*fp2;
  char buf[1000];
  char *buf2;
  if(!(fp = fopen("search.txt","rt"))) {
    fprintf(stderr, "could not open search.txt");
  }
  if(!(fp2 = fopen("BOOKS.TXT","a"))) {
    fprintf(stderr, "could not append to BOOKS.TXT");
  }
  while(fgets(buf,1000,fp)) {
    if(buf2 = strstr(buf, "\"title\"")) {
      buf2 = buf2 + 9;
      printf("%s", buf2);
      fputs(buf2, fp2);
      fputs("\n", fp2);
    }
  }
  fclose(fp2);
  fclose(fp);
  return 0;
}

