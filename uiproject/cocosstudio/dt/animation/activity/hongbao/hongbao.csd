<GameFile>
  <PropertyGroup Name="hongbao" Type="Node" ID="5529ef14-3c9a-4318-b384-1c210dbc9ebc" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="55" Speed="1.0000" ActivedAnimationName="animation0">
        <Timeline ActionTag="-268045465" Property="Position">
          <PointFrame FrameIndex="40" X="-0.2053" Y="-33.7003" />
        </Timeline>
        <Timeline ActionTag="-268045465" Property="Scale">
          <ScaleFrame FrameIndex="40" X="0.8266" Y="0.8266" />
        </Timeline>
        <Timeline ActionTag="-268045465" Property="BlendFunc">
          <BlendFuncFrame FrameIndex="40" Tween="False" Src="770" Dst="1" />
        </Timeline>
        <Timeline ActionTag="-268045465" Property="FrameEvent">
          <EventFrame FrameIndex="40" Tween="False" Value="particle_play" />
        </Timeline>
        <Timeline ActionTag="-476139947" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="5" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="15" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="20" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="25" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="40" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="55" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="-476139947" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="5" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="10" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="15" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="20" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="25" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="40" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="55" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="-476139947" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="5" X="10.0000" Y="10.0000" />
          <ScaleFrame FrameIndex="10" X="-10.0000" Y="-10.0000" />
          <ScaleFrame FrameIndex="15" X="15.0000" Y="15.0000" />
          <ScaleFrame FrameIndex="20" X="-15.0000" Y="-15.0000" />
          <ScaleFrame FrameIndex="25" X="20.0000" Y="20.0000" />
          <ScaleFrame FrameIndex="40" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="55" X="0.0000" Y="0.0000" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="animation0" StartIndex="0" EndIndex="55">
          <RenderColor A="255" R="251" G="80" B="79" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="hb" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="Particle_1" ActionTag="-268045465" Tag="4" IconVisible="True" LeftMargin="-0.2053" RightMargin="0.2053" TopMargin="33.7003" BottomMargin="-33.7003" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="ParticleObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="-0.2053" Y="-33.7003" />
            <Scale ScaleX="0.8266" ScaleY="0.8266" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="dt/animation/activity/hongbao/hb.plist" Plist="" />
            <BlendFunc Src="770" Dst="1" />
          </AbstractNodeData>
          <AbstractNodeData Name="Image_29" ActionTag="-476139947" Tag="231" RotationSkewX="6.6667" RotationSkewY="6.6667" IconVisible="True" LeftMargin="-56.0000" RightMargin="-56.0000" TopMargin="-71.0000" BottomMargin="-71.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
            <Size X="112.0000" Y="142.0000" />
            <Children>
              <AbstractNodeData Name="Image_30" ActionTag="2132109654" Tag="232" IconVisible="True" LeftMargin="24.2127" RightMargin="22.7873" TopMargin="92.3432" BottomMargin="24.6568" CascadeColorEnabled="True" CascadeOpacityEnabled="True" ctype="ImageViewObjectData">
                <Size X="65.0000" Y="25.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="56.7127" Y="37.1568" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5064" Y="0.2617" />
                <PreSize X="0.5804" Y="0.1761" />
                <FileData Type="Normal" Path="dt/animation/activity/hongbao/tjylc_hd_qdshb_wz3.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="dt/animation/activity/hongbao/tjylc_hd_qdshb_hb4.png" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>