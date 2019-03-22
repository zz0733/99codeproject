<GameFile>
  <PropertyGroup Name="ssc" Type="Node" ID="915c634d-f6b4-47e9-bf10-bf14de123945" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="45" Speed="0.2500" ActivedAnimationName="animation0">
        <Timeline ActionTag="-2034921109" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="20" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="45" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="-2034921109" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="10" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="20" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="45" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="-2034921109" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="10" X="449.3773" Y="449.3773" />
          <ScaleFrame FrameIndex="20" X="296.6000" Y="296.6000" />
          <ScaleFrame FrameIndex="45" X="360.0000" Y="360.0000" />
        </Timeline>
        <Timeline ActionTag="-2034921109" Property="FileData">
          <TextureFrame FrameIndex="10" Tween="False">
            <TextureFile Type="Normal" Path="dt/image/hall/sc_effect/ccl_icon2.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="20" Tween="False">
            <TextureFile Type="Normal" Path="dt/image/hall/sc_effect/ccl_icon2.png" Plist="" />
          </TextureFrame>
          <TextureFrame FrameIndex="45" Tween="False">
            <TextureFile Type="Normal" Path="dt/image/hall/sc_effect/ccl_icon2.png" Plist="" />
          </TextureFrame>
        </Timeline>
        <Timeline ActionTag="-2034921109" Property="BlendFunc">
          <BlendFuncFrame FrameIndex="10" Tween="False" Src="1" Dst="771" />
          <BlendFuncFrame FrameIndex="20" Tween="False" Src="1" Dst="771" />
          <BlendFuncFrame FrameIndex="45" Tween="False" Src="1" Dst="771" />
        </Timeline>
        <Timeline ActionTag="510492620" Property="BlendFunc">
          <BlendFuncFrame FrameIndex="15" Tween="False" Src="1" Dst="1" />
        </Timeline>
        <Timeline ActionTag="773484439" Property="Position">
          <PointFrame FrameIndex="15" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="28" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="40" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="773484439" Property="Scale">
          <ScaleFrame FrameIndex="15" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="28" X="1.0587" Y="1.0587" />
          <ScaleFrame FrameIndex="40" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="773484439" Property="RotationSkew">
          <ScaleFrame FrameIndex="15" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="28" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="40" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="773484439" Property="Alpha">
          <IntFrame FrameIndex="15" Value="0" />
          <IntFrame FrameIndex="28" Value="255" />
          <IntFrame FrameIndex="40" Value="0" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="animation0" StartIndex="0" EndIndex="60">
          <RenderColor A="255" R="200" G="6" B="250" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="ccl_icon2_1" ActionTag="-2034921109" Tag="8" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-40.5000" RightMargin="-40.5000" TopMargin="-38.5000" BottomMargin="-38.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="81.0000" Y="77.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="dt/image/hall/sc_effect/ccl_icon2.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Particle_1" ActionTag="510492620" Tag="176" IconVisible="True" LeftMargin="-0.6454" RightMargin="0.6454" TopMargin="5.6817" BottomMargin="-5.6817" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="ParticleObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="-0.6454" Y="-5.6817" />
            <Scale ScaleX="0.5471" ScaleY="0.5471" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="dt/image/hall/sc_effect/ssc_effect.plist" Plist="" />
            <BlendFunc Src="1" Dst="1" />
          </AbstractNodeData>
          <AbstractNodeData Name="ssc_2_1" ActionTag="899810669" Tag="174" IconVisible="True" LeftMargin="-52.1972" RightMargin="-53.8028" TopMargin="-48.1919" BottomMargin="-46.8081" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="106.0000" Y="95.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="0.8028" Y="0.6919" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="dt/image/hall/sc_effect/ccl_icon.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="ssc_2_1_0" ActionTag="773484439" Alpha="0" Tag="10" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-53.0000" RightMargin="-53.0000" TopMargin="-47.5000" BottomMargin="-47.5000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="106.0000" Y="95.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="dt/image/hall/sc_effect/ccl_icon.png" Plist="" />
            <BlendFunc Src="770" Dst="1" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>