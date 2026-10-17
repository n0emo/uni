use std::sync::Arc;

use itertools::Itertools as _;
use s3::{creds::Credentials, Bucket, BucketConfiguration, Region};
use tracing::info;

#[derive(Clone)]
pub struct ImageService {
    bucket: Arc<Bucket>,
}

impl ImageService {
    pub async fn new(endpoint: String, access_key: &str, secret_key: &str) -> anyhow::Result<Self> {
        info!("Creating Minio bucket");

        let bucket_name = "pgups-images";
        let region = Region::Custom {
            region: "eu-central-1".to_owned(),
            endpoint,
        };
        let credentials = Credentials::new(Some(access_key), Some(secret_key), None, None, None)?;

        let bucket = {
            let mut bucket = Bucket::new(bucket_name, region.clone(), credentials.clone())?.with_path_style();

            if !bucket.exists().await? {
                bucket = Bucket::create_with_path_style(
                    bucket_name,
                    region,
                    credentials,
                    BucketConfiguration::default()
                ).await?.bucket;
            }

            Arc::new(*bucket)
        };


        Ok(Self { bucket })
    }

    pub async fn list_all(&self) -> anyhow::Result<Vec<String>> {
        let images = self.bucket.list("".to_owned(), Some("/".to_owned())).await?;
        Ok(images.into_iter()
            .flat_map(|i| i.contents.into_iter())
            .sorted_by_key(|o| o.last_modified.clone())
            .map(|o| o.key)
            .collect())
    }

    pub async fn get(&self, path: &str) -> anyhow::Result<(Vec<u8>, String)> {
        let content_type = self.bucket.head_object(path).await?.0.content_type
            .ok_or_else(|| anyhow::anyhow!("There is no content-type in response from Minio"))?;
        let image = self.bucket.get_object(path).await?;
        Ok((image.to_vec(), content_type))
    }

    pub async fn put(&self, image: &[u8], name: &str, content_type: &str) -> anyhow::Result<()> {
        self.bucket.put_object_with_content_type(name, image, content_type).await?;
        Ok(())
    }
}
