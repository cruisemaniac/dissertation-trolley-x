"""Launch the UWB ranging driver on its own for bring-up and testing.

Starts uwb_ranging. It reads both cart anchors (ttyAMA0 = right, ttyAMA2 = left)
and publishes /uwb/right and /uwb/left as sensor_msgs/Range. The follow
controller is a separate node, added later.
"""

from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    return LaunchDescription([
        Node(
            package='trolley_core',
            executable='uwb_ranging',
            name='uwb_ranging',
            output='screen',
            parameters=[{
                'right_port': '/dev/ttyAMA0',
                'left_port': '/dev/ttyAMA2',
                'baud_rate': 115200,
                'tag_address': 'TAG00001',
                'network_id': 'TROLLEYX',
                'configure_on_start': True,
            }],
        ),
    ])
