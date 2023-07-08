#!/usr/bin/env python3

import argparse
import json
import logging
import os

import boto3

logging.basicConfig(format='%(asctime)s %(message)s', level=logging.DEBUG + 1)


def get_env(env_var_name: str) -> str:
    env_var_value = os.getenv(env_var_name, None)
    if not env_var_value:
        raise AssertionError(f'"{env_var_name}" should be specified')
    return env_var_value


AWS_ACCESS_KEY_ID = get_env('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = get_env('AWS_SECRET_ACCESS_KEY')
S3_BUCKET = 'mybucket'
S3_IMAGES_FOLDER = 'images'


def upload_file_to_s3(local_file_path: str, s3_image_path: str):
    logging.info(f'Upload {local_file_path} to s3 -> {S3_BUCKET}/{s3_image_path}')
    s3_client = boto3.resource('s3', aws_access_key_id=AWS_ACCESS_KEY_ID, aws_secret_access_key=AWS_SECRET_ACCESS_KEY)

    s3_client.meta.client.upload_file(
        local_file_path,
        S3_BUCKET,
        f'{s3_image_path}',
        ExtraArgs={'ACL': 'public-read'}
    )


def parse_args():
    argparser = argparse.ArgumentParser()
    argparser.add_argument('-i', '--image', required=True, help='path to image file')
    argparser.add_argument('-p', '--parent', help='parent image name')
    argparser.add_argument('--s3-path', help='skip deployment to s3, just use predefined path')

    subparsers = argparser.add_subparsers()
    cloud_parser = subparsers.add_parser('cloud', help='cloud specific params')
    cloud_parser.add_argument('-c', '--config', help='path to cloud image config file')
    cloud_parser.add_argument('-bc', '--base-config', help='path to cloud image base config file')

    return argparser.parse_args()


def _mergedicts(dict1, dict2):
    for k in set(dict1.keys()).union(dict2.keys()):
        if k in dict1 and k in dict2:
            if isinstance(dict1[k], dict) and isinstance(dict2[k], dict):
                yield (k, dict(_mergedicts(dict1[k], dict2[k])))
            else:
                # If one of the values is not a dict, you can't continue merging it.
                # Value from second dict overrides one in first and we move on.
                yield (k, dict2[k])
                # Alternatively, replace this with exception raiser to alert you of value conflicts
        elif k in dict1:
            yield (k, dict1[k])
        else:
            yield (k, dict2[k])


def get_cloud_config(config: str = None, base_config: str = None) -> dict:
    base_cloud_config = {}
    cloud_config = {}

    if base_config:
        with open(base_config) as base_cloud_config_file:
            base_cloud_config = json.load(base_cloud_config_file)
    if config:
        with open(config) as cloud_config_file:
            cloud_config = json.load(cloud_config_file)
    return dict(_mergedicts(base_cloud_config, cloud_config))


def deploy_image_to_cloud(image_name: str, s3_image_path: str, cloud_config: dict):
    ...


def get_image_version(image_name: str) -> int:
    ...


def get_image_version_from_s3(image_name: str) -> int:
    s3_client = boto3.resource('s3', aws_access_key_id=AWS_ACCESS_KEY_ID, aws_secret_access_key=AWS_SECRET_ACCESS_KEY)
    existing_versions = []
    for image in s3_client.Bucket(S3_BUCKET).objects.filter(Prefix=f"{S3_IMAGES_FOLDER}/{image_name}"):
        # key will be like - images/ubuntu-20.04-base/v1/ubuntu-20.04-base.qcow2
        existing_versions.append(int(image.key.split('/')[2].split('v')[1]))

    if existing_versions:
        return sorted(existing_versions)[-1] + 1
    return 1


def deploy_image():
    args = parse_args()

    image_name = args.image.split("/")[-1].split(".qcow2")[0]

    if args.s3_path:
        s3_image_path = args.s3_path
    else:
        s3_image_path = f"{S3_IMAGES_FOLDER}/{image_name}/v{get_image_version_from_s3(image_name)}/{image_name}.qcow2"
        upload_file_to_s3(args.image, s3_image_path)

    if hasattr(args, 'config') or hasattr(args, 'base_config'):
        deploy_image_to_cloud(image_name, s3_image_path, get_cloud_config(args.config, args.base_config))


if __name__ == '__main__':
    deploy_image()
