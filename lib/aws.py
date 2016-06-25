import boto3

class aws(object):
    def __init__(self, region,secret_key,access_key):
        self.boto3client = boto3.client('ec2', region_name=region, aws_access_key_id=access_key, aws_secret_access_key=secret_key)

    def get_images(self):
        images = self.boto3client.describe_images(Owners=["self"])
        return images['Images']

    def get_stack_images(self,stack):
        images = self.get_images()
        ret= []
        for image in images:
            if image['Name'].startswith("%s_" % (stack,)):
                puppet_role = get_value_from_array_hash(dictlist=image.get('Tags'),key="Puppet_role")
                if puppet_role is not None and puppet_role == stack:
                    ret.append(image)
        return ret

    def cleanup_stack_images(self,stack):
        stack_images = self.get_stack_images(stack=stack)
        if len(stack_images) == 0:
            print "Something went wrong with image generation"
            raise EnvironmentError
        elif len(stack_images) == 1:
            print "Only one image exists done"
        else:
            print "Running Cleanup"
            times = {}
            for i in stack_images:
                stack_name = i.get('Name')
                split = stack_name.split("_")
                times[i.get('ImageId')] = split[-1]
            oldest = get_largest_value_from_dict(dictlist=times)
            times.pop(oldest,0)
            self.reset_tag(id=list(times.keys()))

    def reset_tag(self,id):
        self.boto3client.create_tags(Resources=id,Tags=[{'Key': 'Puppet_role','Value': ''}])

def get_value_from_array_hash(dictlist=None, key=None):
    try:
        ret = filter(lambda x: x['Key'] == key, dictlist)[0]['Value']
    except IndexError:
        ret = None
    return ret

def get_largest_value_from_dict(dictlist):
    maxx = max(dictlist.values())
    keys = [x for x,y in dictlist.items() if y ==maxx]
    return keys[0]