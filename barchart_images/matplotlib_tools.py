import matplotlib.pyplot as plt
from matplotlib.offsetbox import OffsetImage,AnnotationBbox,TextArea


def bar_plot_with_images(df_to_plot, img_list, bartop_labels=[], bartop_label_pattern='', xtick_labels=[], orientation='v', img_scale=0.15, x_offset=0, y_offset=0, bartop_label_rotation=0, frameon=True, **kwargs):
    fig, ax = plt.subplots()
    # fig = plt.figure()
    # ax  = fig.add_axes()

    if orientation.lower()=='v':
        df_to_plot.plot(
            kind="bar",
            ax=ax,
            **kwargs
        )
        ax.grid(axis='y')
    
    else:
        df_to_plot.plot(
            kind="barh",
            ax=ax,
            **kwargs
        )
        ax.grid(axis='x')


    #-- Overide AxesSubplot returned by pandas with with Matplotlib axis
    # ax = plt.gca()
    #fig, ax = plt.subplots()


    #-- Annotate each bar in the chart with an image
    xticks_locations = []
    for bar, img, top_label in zip(ax.patches, img_list, bartop_labels):

        #-- get bar coordinates
        bar_x_pos = bar.get_x()
        bar_y_pos = bar.get_y()

        _x_offset = x_offset + (bar.get_width()/2)
        _y_offset = y_offset + bar.get_height()

        _x = bar_x_pos + _x_offset
        _y = bar_y_pos + _y_offset

        xticks_locations.append(_x)
        #-- create an annotation box container for each image
        imagebox = OffsetImage(img, zoom = img_scale)
        #imagebox.image.axes = ax
        ab = AnnotationBbox(imagebox, (_x,_y), frameon=frameon)
        
        ax.add_artist(ab)
        
        _value:str = f"{bartop_label_pattern}: {top_label}"
        ax.annotate(_value, (bar.get_x() * 1.005, bar.get_height() * 1.005), rotation=bartop_label_rotation)  #annotate text

    #-- Some options that can probably be commented out     
    ax.legend()
    if len(xtick_labels) == 0:
        xtick_labels = df_to_plot.index
    ax.set_xticks(ticks=xticks_locations, labels=xtick_labels)


    
        