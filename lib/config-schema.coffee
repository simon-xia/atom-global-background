module.exports =
    imageSource:
        type: 'object'    
        properties:    
            source:    
                title: 'Images Source'
                type: 'string'
                default: 'Custom Image Source'
                enum: ['Custom Image Source', 'Random Image from Internet']    
                order: 1    
            custom:
                type: 'object'    
                properties:    
                    urls:
                        type: 'object'    
                        properties:
                            enabled:
                                title: 'Custom Image URLs - Enabled'    
                                description: 'Enable custom image from Internet'    
                                type: 'boolean'   
                                default: true    
                            source:    
                                title: 'Custom Image URLs - Source'    
                                description: 'Custom image\'s urls from Internet (seperated by commas with no space)'    
                                type: 'array'    
                                default: ["http://www.uestc.edu.cn/public/2014/04/024.jpg"]
                                items:
                                    type: 'string'    
                        order: 1
                    paths:
                        type: 'object'    
                        properties:
                            enabled:
                                title: 'Custom Image Paths - Enabled'    
                                description: 'Enable custom image from Internet'    
                                type: 'boolean'   
                                default: false    
                            source:    
                                title: 'Custom Image Paths - Source'    
                                description: 'Custom image\'s paths from local (seperated by commas with no space)'    
                                type: 'array'    
                                default: []    
                                items:
                                    type: 'string'    
                        order: 2
                    randomEnable:
                        title: 'Random Enable'    
                        description: 'random order in customized image source'    
                        type: 'boolean'    
                        default: false  
                        order: 3
                order: 2    
            Internet:
                type: 'object'    
                properties:
                    width:
                        title: 'Image Width'
                        type: 'number'
                        default: 1368
                        order: 1    
                    height:
                        title: 'Image Height'
                        type: 'number'
                        default: 768
                        order: 2    
                    category: 
                        title: 'Image Category'    
                        description: 'e.g: food, sport, nature, Read: http://lorempixel.com/'
                        type: 'string'  
                        default: ''
                        order: 3    
                    type:
                        title: 'Image Type'
                        type: 'string'
                        description: 'color image or grey image'
                        default: 'color image'
                        enum: ['color image', 'grey image']
                        order: 4    
                order: 3    
    refreshRate:
        title: 'Refresh Rate'
        description: 'How often the background is refreshed (in seconds).'
        type: 'number'
        default: 300    
        